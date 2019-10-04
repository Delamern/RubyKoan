# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutRegularExpressions < Neo::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class #Is asserting that the class of some rexex pattern is a regexp
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal "match", "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil #returns nil and not an empty string
    assert_equal nil, "some matching content"[/missing/]
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional #Zero or one of the specified character
    assert_equal "ab", "abbcccddddeeeee"[/ab?/] #Find "ab" if possible, or just "a" if not
    assert_equal "a", "abbcccddddeeeee"[/az?/]

    assert_equal "a", "aaaa"[/ab?/] # Demo will grab one at most
    assert_equal "colour", "colour color"[/colou?r/] #grabs the first match
  end

  def test_plus_means_one_or_more #Greedy - will look for as many as possible.
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/]

    assert_equal nil, "abb"[/bc+/] #Will never match as there is no "bc"
  end

  def test_asterisk_means_zero_or_more #Greedy - will look for as many as possible when it does find a match
    assert_equal "abb", "abbcccddddeeeee"[/ab*/]
    assert_equal "a", "abbcccddddeeeee"[/az*/]
    assert_equal "", "abbcccddddeeeee"[/z*/] #Since it is expecting zero or more, if there are zero that is still a match - so "" returned instead of nil

    assert_equal "a", "acbb"[/ab*/] #won't pull any b if there is something between it and the a
    assert_equal "abbb", "abbbcb"[/ab*/] #won't find the second b if it's split from the first

    # THINK ABOUT IT:
    #
    # When would * fail to match?
    # Never. Accepts 0 matches as a match.
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
  # Greedy means they will keep grabbing until they have nothing else that matches, instead of just stopping at the first possible end point

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal "a", "abbccc az"[/az*/] #Ah, the thing I was checking up above....
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] } #I'm more intrigued about what the "|a| a" is doing...
    #Asked a friend, the |a| is defining that a is a variable.
    #Select creates a new array of all elements that returned true
    #a[/cbr]at/] is saying that each element (a) needs to match against the regex expression next to it and return what it found.
    # https://ruby-doc.org/core-2.4.1/Array.html#method-i-select
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal "42", "the number is 42"[/[0123456789]+/] #looking for one or more digits that match any of the characters in the []
    assert_equal "42", "the number is 42"[/\d+/] #Note: Is returning as a string and not int
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class #what they mean by this is any character, _, or digit
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal "variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal "variable_1", "variable_1 = 42"[/\w+/]

    assert_equal "42", "42 variable_1"[/\w+/]
    assert_equal "42", "$42 variable_1"[/\w+/] #doesn't accept non _ symbols
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal "abc", "abc\n123"[/a.+/]
    assert_equal "abc 123", "abc 123"[/a.+/]
  end

  def test_a_character_class_can_be_negated
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/] #saying anything that ISN'T a digit is a match
  end

  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal "42", "the number is 42"[/\d+/]
    assert_equal "the number is ", "the number is 42"[/\D+/]

    assert_equal " \t\n", "space: \t\n"[/\s+/]
    assert_equal "space:", "space: \t\n"[/\S+/]

    # ... a programmer would most likely do
    assert_equal " = ", "variable_1 = 42"[/[^a-zA-Z0-9_]+/] #match anything that isn't a character, number, or underscore
    assert_equal " = ", "variable_1 = 42"[/\W+/]
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal "start", "start end"[/\Astart/]
    assert_equal nil, "start end"[/\Aend/]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal "end", "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/]
  end

 #Caret and $ are useful for parsing multi-line files -- can apply operations to each line.
  def test_caret_anchors_to_the_start_of_lines
    assert_equal "2", "num 42\n2 lines"[/^\d+/]

    assert_equal nil, "num 42\nblah 2 lines"[/^\d+/]
    assert_equal "42", "42 num\nlines 2"[/^\d+/]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal "42", "2 lines\nnum 42"[/\d+$/]

    assert_equal nil, "2 lines\n42 num"[/\d+$/]
    assert_equal "2", "lines 2\n42 num"[/\d+$/]
  end

  def test_slash_b_anchors_to_a_word_boundary
    assert_equal "vines", "bovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    assert_equal "hahaha", "ahahaha"[/(ha)+/]
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1]
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2]
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/] #Note the comma in the regex, thats what is making the Name: Gray not match
    assert_equal "Gray", $1
    assert_equal "James", $2
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays]
    assert_equal "Summer", "Summer Gray"[grays, 1]
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).
  # | is looking for exact matches, [] is looking for any single thing that matches anything it has
  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
    assert_equal ["one", "two", "three"], "one two-three".scan(/\w+/)
  end

  #Sub retruns a copy of str with the first occurrence of pattern replaced by the second argument.
  def test_sub_is_like_find_and_replace
    # This says fine any word that starts with t, then make the first occurence only one character long
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }

    assert_equal "one tw-three", "one two-three".sub(/(t\w*)/) { $1[0, 2] }
    assert_equal "one two-three", "one two-three".sub(/(t\w*)/) { $1[0, 3] }
    assert_equal "one two-three", "one two-three".sub(/(t\w*)/) { $1[0, 4] }
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
    assert_equal "one tw-th", "one two-three".gsub(/(t\w*)/) { $1[0, 2] }
    assert_equal "one two-thr", "one two-three".gsub(/(t\w*)/) { $1[0, 3] }
  end
end
