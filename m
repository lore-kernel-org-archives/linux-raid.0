From: "Sleight of Mind" <sleight@xs4all.nl>
Subject: Promise TX2000 causing 'lost interrupt' messages
Date: Wed, 30 Oct 2002 02:12:44 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <17888.80.56.177.209.1035940364.squirrel@webmail.xs4all.nl>
Reply-To: sleight@xs4all.nl
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm new to this list. I subscribed today hoping it's members could help me
with my problem.
I got a Promise TX2000 Software RAID controller. I want to use ataraid for it,
but i can't get it to work. I compiled a 2.4.19 kernel with support for the
promise card, ataraid and some extra features (as described in many howto's).
I also used an append line in lilo to set ide0 and ide1 (i use the swap IDE
channels kernel option as well).
During boottime, ide0 and ide1 are detected with the options i specified. My
HDDs are also detected as hda and hdc. After this, i get messages like:

hda: lost interrupt

Same for hdc. The boot process continues though, but very slowly. Can someone
help me with this problem?

Tia

-- 
Sleight of Mind

<your ad here, if not extending 2 colors>
