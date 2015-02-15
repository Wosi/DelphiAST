unit DelphiAST.Writer;

interface

uses
  DelphiAST.Classes, SysUtils;

type
  TSyntaxTreeWriter = class
  private
    class procedure NodeToXML(const Builder: TStringBuilder; 
      const Node: TSyntaxNode; Formatted: Boolean); static;
  public
    class function ToXML(const Root: TSyntaxNode; 
      Formatted: Boolean = False): string; static;
  end;

implementation

uses
  Generics.Collections;

{ TSyntaxTreeWriter }

class procedure TSyntaxTreeWriter.NodeToXML(const Builder: TStringBuilder; 
  const Node: TSyntaxNode; Formatted: Boolean);

  procedure NodeToXMLInternal(const Node: TSyntaxNode; const Indent: string);
  var
    HasChildren: Boolean;  
    NewIndent: string;
    Attr: TPair<string, string>;
    ChildNode: TSyntaxNode;
  begin
    HasChildren := Node.HasChildren;
    if Formatted then
    begin
      NewIndent := Indent + '  ';
      Builder.Append(Indent);
    end;
    Builder.Append('<' + UpperCase(Node.Name));  
    for Attr in Node.Attributes do
      Builder.Append(' ' + Attr.Key + '="' + Attr.Value + '"');  
    if HasChildren then
      Builder.Append('>')
    else
      Builder.Append('/>');
    if Formatted then
      Builder.AppendLine;
    for ChildNode in Node.ChildNodes do
      NodeToXMLInternal(ChildNode, NewIndent);
    if HasChildren then
    begin
      if Formatted then
        Builder.Append(Indent); 
      Builder.Append('</' + UpperCase(Node.Name) + '>');
      if Formatted then
        Builder.AppendLine;
    end;
  end;
  
begin
  NodeToXMLInternal(Node, '');
end;

class function TSyntaxTreeWriter.ToXML(const Root: TSyntaxNode; 
  Formatted: Boolean): string;
var
  Builder: TStringBuilder;
begin
  Builder := TStringBuilder.Create;
  try
    NodeToXml(Builder, Root, Formatted);
    Result := '<?xml version="1.0"?>' + sLineBreak + Builder.ToString;
  finally
    Builder.Free;
  end;
end;

end.
