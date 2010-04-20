---
title: Querying for a Date Range (Specific Month or Day)
created_at: 2010-04-20 15:03:24.036546 -04:00
recipe: true
author: Mike Dirolf
description: How to query for documents from a certain month or day.
filter:
  - erb
  - markdown
---

### Problem

You want to list all of the documents in a collection (in the example
we'll use "posts") that were created in a particular month.  Each
document in the collection has a field representing the date it was
created:

<% code 'javascript' do %>
{
    "title" : "A blog post",
    "author" : "Mike",
    "content" : "...",
    "created_on" : new Date();
}
<% end %>

We want to perform a query to get all documents whose value for
`created_on` is in the month of April, 2010.

### Solution

Use a range query to query for documents whose value for `created_on`
is greater than a Date representing the start of the month, and less
than a Date representing the end.

#### 1. Construct Date objects representing the start and end of the month

Our first step is to construct Date instances that we can use to do
the range query. In JavaScript:

<% code 'javascript' do %>
var start = new Date(2010, 3, 1);
var end = new Date(2010, 4, 1);
<% end %>

Note that in JS the month portion of the Date constructor is
0-indexed, so the `start` variable above is April 1st and the `end`
variable is May 1st. The logic here is similar in all languages, in Python we'd do:

<% code 'python' do %>
>>> from datetime import datetime
>>> start = datetime(2010, 4, 1)
>>> end = datetime(2010, 5, 1)
<% end %>

#### 2. Perform a range query

Now that we have our reference dates, we can perform a range query to
get the matching documents, note the use of the special `$` operators,
`$gte` (greater-than) and `$lt` (less-than):

<% code 'javascript' do %>
db.posts.find({created_on: {$gte: start, $lt: end}});
<% end %>

Again, this translates nicely to other languages - in Python it's:

<% code 'python' do %>
>>> db.posts.find({"created_on": {"$gte": start, "$lt": end}})
<% end %>

#### 3. Use an index for performance

To make these queries fast we can use an index on the `created_on` field:

<% code 'javascript' do %>
db.posts.ensureIndex({created_on: 1});
<% end %>

We can also use a compound index if we're performing a query on author
and a date range, like so:

<% code 'javascript' do %>
db.posts.ensureIndex({author: 1, created_on: 1});
db.posts.find({author: "Mike", created_on: {$gt: start, $lt: end}});
<% end %>

