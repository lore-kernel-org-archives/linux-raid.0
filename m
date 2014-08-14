From: Ram Ramesh <rramesh2400@gmail.com>
Subject: How to use --freeze-reshape  and is it safe?
Date: Thu, 14 Aug 2014 00:38:43 -0500
Message-ID: <53EC4B63.90703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was browsing through mdadm man pages to check out --layout options 
when converting 3disk-raid5 to 4disk-raid6 and encountered 
--freeze-reshape switch/arg. I did a quick google and could not get much 
info. Can a user issue this to suspend reshape for a short while? 
Specifically

 1. Is the use (or frequent use) of this switch safe? recommended?
 2. Can the array be mounted when this switch is used?
 3. What is correct syntax for the usage?
 4. Can I use this to manage the reshape load on an array? May be to let
    the disk cool off after a busy hours of seeking to reshape?
 5. Can I use it as a safe method for shutting down  the machine?
 6. Is there a tutorial/faq/manual that explains in detail the use of
    other mdadm esoteric switches? (like --layout I was searching)

Regards
Ramesh

