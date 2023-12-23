class String
  def squiggly_heredoc
    self.lines.map(&.strip).join("\n") + '\n'
  end
end
