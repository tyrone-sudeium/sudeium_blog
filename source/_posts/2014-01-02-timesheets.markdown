---
layout: post
title: "Timesheets"
date: 2014-01-02 22:05
comments: true
categories: [Programming, Project Management, Rant]
---

There's a big disconnect in the professional IT world between the various
managers attached to the project and the development team. This usually results
in amusing quirks and inefficiencies and a whole lot of documentation. One of
the forms of documentation is time logging -- that is, how much time each
developer spent on a given task/story/unit-of-work. Some companies -- usually
the small ones -- trust their developers to do the work and just track progress
by watching tickets change status. Others require developers, particularly
contractors, to log all their billable hours to a task in the project, with
an expectation that the time spent should match up with the estimates.

<!--more-->

It's a slippery slope that has a tendency to quickly result in a ridiculous
obsession with timesheets. It culminates in the company requiring that
employees fill out timesheets *daily* with an expectation that they're
accurate to the *minute*. These timesheets must also have the exact start
time and end time for every bit of work you did on a specific task. If you fail
to do so, they'll threaten to withhold your pay until you do.

No, I'm serious. This is an actual thing happening in Australia right now.
First off, a disclaimer. I no longer work for the company referred to in the
rest of this post. I haven't worked there for a while now, but I still
occasionally hear rumblings from disgruntled staff still working there, usually
by second or even *third* degree connections.

The following quote is from a staff email sent by the company in question.
Any references by name are removed, but you know who you are and you should
be ashamed. This was sent out around about midday on the last day of work for
2013.

> We sent two separate emails requesting that timesheets be completed by 12 pm
> today and yet 10 people chose to go to lunch without completing that simple
> task.
> 
> This is very disappointing.  Please note that we are within our legislative 
> rights to withhold the pays of staff who are refusing to comply with 
> [our] policies and confirm their attendance by entering timesheets as
> requested.
> 
> If your timesheets are not currently (as of right now) entered up to and 
> including 12 pm today, your pay will not be processed this week.

Let's deconstruct some of the things in this email to work out just how big a
travesty it really is:

> 10 people chose to go to lunch with completing that simple task...

So they were actually watching everyone who left the office and checking them
against a "naughty list"? Wow, Kim Jong-Un isn't even that heavy handed.

> "Simple task"

Let's talk about this so called "simple task" then, shall we? At this company,
you are expected to include both the start time and the end time for when you
worked on a given task. Sounds reasonable enough like that, but think about the
average day of a developer in a development agency. They may be working on 2,
perhaps even 3 projects at a time; even more if they're a senior. This means
being constantly pulled off a task, and having to remember exactly which time
they stopped. Each interruption splits the entry you have to put into their
timesheet software into two distinct entries, so the more interruptions, the
more entries.

The software is incredibly slow, unintuitive and buggy. It's developed in-house
because I guess this company figures they can do a better job than Atlassian
can? Even if they did use something like JIRA, JIRA is already very slow at
this type of stuff, and this custom software is an order of magnitude slower
again.

Why not just do your timesheets "as you go"? Because most of the time these
interruptions are caused by a manager coming to your desk and chatting, usually
resulting in you doing "just a quick thing". It's a faux pas to have a manager
come to your desk and for you to say "just a sec" while you:

1. Drop what you're doing.
2. Open your browser.
3. Navigate to the timesheet site.
4. Fumble your way through the horrendous project list.
5. Fumble your way through the horrendous task list.
6. Try to find the task you were working on, at which you could:
  - Actually find a relevant task (rare!)
  - Not find one but looking through the comments of another, deem it "close
    enough".
  - Not find one anywhere near close enough, so dump it in a "bucket" task,
    or a "tech task".
7. Try desperately to remember when you started whatever it was you were doing.
8. Manually enter the time *and date* for both start and finish.
9. Try to think of a meaningful comment to put in with the timesheet entry. Oh
   yeah I forgot to mention, all entries must have a comment!
10. Turn to find the manager is no longer at your desk.
11. See the manager in the CEO's office, ranting about how "inefficient" and
    slow you are.
12. Try to go back to what you were doing, but all context has been lost and
    you have to find your train of thought all over again.

As a result of this, most of the people interested in actually getting *work*
done -- you know, the shit they *pay* you to do -- will just wait until the
end of the day and do all the timesheets in one big hit. On a good day, it'll
take 15 minutes, on a really bad day it could take up to an hour depending on
how slow the software feels like being. There is *no* task in the system for
for logging time spent doing timesheets. Apparently this is to prevent "abuse",
but to the worker it just smells like they're deliberately not collecting data
on how time consuming this task is because they don't want to know. I'm 
reminded of a child covering their ears and yelling "LA LA LA LA CAN'T HEAR 
YOU!".

> ...we are within our legislative rights to withhold the pays of staff...

First thing to keep in mind here, the vast majority of employees at this
company are *not* contractors, they are full-time staff. Correct me if I'm
wrong, but you can't threaten to withhold pay from a full-time staff member;
the legislation they're talking about allows employers to terminate the
employment due to incompetence, but that's a whole different story to simply
refusing to pay them that pay cycle. Someone at this company should probably
actually seek the advice of legal counsel, because something here seems fishy.

> If your timesheets are not current... your pay will not be processed this 
> week.

They've made such threats multiple times during my tenure, but in my experience
they've never actually gone through with that threat. I've heard of contractors
not getting paid, but that's really to be expected.

They also have no real way to ascertain whether the time entered by employees
is actually accurate. They can compare against the estimate, but if the two
don't match up that typically means that the estimate is wrong, right? Well,
because timesheeting is *such* a ridiculously painful, convoluted and tedious
task, I've noticed many instances of employees just putting shit into the
system so that the system will say they've worked all the hours in a given day
that they're meant to. There's absolutely no science to it, none of the numbers
are necessarily accurate in any way, but the project managers will treat it as
gospel and this employee will get paid. None of the people doing this were ever
caught.

The people getting threatened with no pay are the ones who haven't entered
anything at all -- probably because they were too busy *working*. The ones
that fudge the numbers get to leave work on time, get to have lunch and have
no risk of not getting paid. The ones who put in accurate numbers generally
stay late to do them (since there's no timesheeting task), so go home late,
are generally more stressed and aggravated and still have to put up with the
threats when they don't meet the company's absurd requirements.

So, there you have it. This company's Christmas present to their loyal
employees is a threat to withhold pay if they don't perform a tedious, and
ultimately useless task. The typical cynical project manager response to this
is "it's a job, you have to do stuff you don't like. That's why you get paid."
Well, that's true, you'll often have to do stuff you don't like, but then you
shouldn't be surprised when your staff members leave; especially the good
ones. The ones that are hard to replace. The ones that care about their work.
The ones that would otherwise be loyal, efficient, ambitious and produce
quality output. The ones that would be the most profitable to the company.
When you lose these people, just remember:

You brought it upon yourself.