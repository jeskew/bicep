// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
using System;
using System.Linq;
using System.Text;
using Bicep.Core.Diagnostics;
using Bicep.Core.Parsing;
using Bicep.Core.PrettyPrint.Options;
using Bicep.Core.Syntax;

namespace Bicep.Core.PrettyPrint
{
    public static class PrettyPrinter
    {
        public static string PrintValidProgram(ProgramSyntax programSyntax, PrettyPrintOptions options) =>
            PrintProgram(programSyntax, options, EmptyDiagnosticLookup.Instance, EmptyDiagnosticLookup.Instance);

        public static string PrintProgram(ProgramSyntax programSyntax, PrettyPrintOptions options, IDiagnosticLookup lexingErrorLookup, IDiagnosticLookup parsingErrorLookup)
        {
            string indent = options.IndentKindOption == IndentKindOption.Space ? new string(' ', options.IndentSize) : "\t";
            string newline = options.NewlineOption switch
            {
                NewlineOption.LF => "\n",
                NewlineOption.CRLF => "\r\n",
                NewlineOption.CR => "\r",
                _ => InferNewline(programSyntax)
            };

            var documentBuildVisitor = new DocumentBuildVisitor(lexingErrorLookup, parsingErrorLookup);
            var sb = new StringBuilder();

            var document = documentBuildVisitor.BuildDocument(programSyntax);
            document.Layout(sb, indent, newline);

            if (options.InsertFinalNewline)
            {
                sb.Append(newline);
            }

            return sb.ToString();
        }

        public static string PrintValidSyntax(SyntaxBase syntax, PrettyPrintOptions options)
        {
            string indent = options.IndentKindOption == IndentKindOption.Space ? new string(' ', options.IndentSize) : "\t";

            var sb = new StringBuilder();
            var documentBuildVisitor = new DocumentBuildVisitor(EmptyDiagnosticLookup.Instance, EmptyDiagnosticLookup.Instance);

            var document = documentBuildVisitor.BuildDocument(syntax);
            document.Layout(sb, indent, Environment.NewLine);
            return sb.ToString();
        }

        private static string InferNewline(ProgramSyntax programSyntax)
        {
            var firstNewlineToken = (Token?)programSyntax.Children
                .FirstOrDefault(child => child is Token token && token.Type == TokenType.NewLine);

            if (firstNewlineToken != null)
            {
                return StringUtils.MatchNewline(firstNewlineToken.Text);
            }

            return Environment.NewLine;
        }
    }
}
