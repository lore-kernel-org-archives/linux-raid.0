From: Michael Stumpf <mjstumpf@pobox.com>
Subject: detecting/correcting _slightly_ flaky disks
Date: Mon, 05 Mar 2007 08:56:09 -0600
Message-ID: <45EC2F89.2070703@pobox.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com> <17898.45673.573800.56474@notabene.brown>	<45EB3867.8050907@eyal.emu.id.au> <17899.18568.523543.478792@notabene.brown> <45EBCA83.40106@eyal.emu.id.au>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EBCA83.40106@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to assemble an array (raid 5) of 8 older, but not yet old age 
ATA 120 gig disks, but there is intermittent flakiness in one or more of 
the drives.  Symptoms:

* Won't boot sometimes.  Even after moving to 2 power supplies and 
monitoring the amp spikes, sometimes I get "clicking" from 1-2 of the 
drives after the startup.

* When initiating a SMART long test, so far two of them have:
       + passed 50-75% of the time
       + when "failed", didn't actually fail, just perpetually were 
stuck at an arbitrary % of test remain.
       + If I cancel and restart the test, often they pass.

I've heard clicking from some drives when executing SMART long tests.  
Doing 4 drives at a time, but still can't
isolate and don't want to use laborious "sit and listen by computer" 
method to determine which are dying--would prefer a tool to detect the 
issue.

I know there's a problem with one or more because my issues with my 
primary array disappeared the minute I used LVM to remove these devices 
(and upgrade to some larger/newer ones).

Two questions:

1)  Is it smartest to isolate which drives are clicking and chuck them 
into the wood chipper, given the circumstances?

2)  Are there tools that are designed to determine if a drive is fit for 
duty?  dd_rescue et all seem focused on saving a dying drive; spinrite 
seems to be controversial black magic marketing, etc.  I could try the 
manufacturer shipped tools but given their black box nature I have no 
idea how much (or little) is being done by their tests.  What do you 
folks recommend?

Thanks in advance.
--Michael Stumpf
