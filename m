From: Matthias Walther <matthias@walther.xyz>
Subject: Unexpected mdadm behavior with old replugged disc
Date: Sat, 18 Nov 2017 15:35:35 +0100
Message-ID: <239f7f18-00d3-254a-e460-24b40e9db5e1@walther.xyz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I just signed up for this mailing list to discuss the following,
unexpected behavior:

Situation: Raid6 with 6 discs. For some reasons, which are unimportant,
I had replaced a disc before, which was fully functional. This disc was
never changed or written to in between.

Today I replugged this particular disc additionally as 7th disc to the
server (cold plug, server was switched off).

Unexpectedly mdadm broke up my fully synced raid6 and now syncs back to
this old disc dropping one of the newer discs from the raid.

This might be because it has its uuid still stored with higher rank than
the newer disc or because the old disc got a lower sdX slot. I don't
know that in detail.

Anyway, I wouldn't expect mdadm to act like this. It might use the old,
now plugged in again disc as hot spare or ignore it at all. But it
shouldn't break a fully synced raid. I have reduced redundancy for about
24 hours now - without any rational reason.

Especially as this isn't a usual use case. In general, you'd only
replace broken discs. So this behavior makes even less sense to me,
because it shouldn't try to use a potentially broken disc.

Is this a bug? Or maybe something the developer's haven thought of, or
is this just unprecedented?

The kernel version is 4.14 mainline on Ubuntu 16.04 LTS.

Regards,
Matthias
