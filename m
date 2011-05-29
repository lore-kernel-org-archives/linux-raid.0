From: Michael Stumpf <mjstumpf@gmail.com>
Subject: filesystem-level tool to validate array
Date: Sun, 29 May 2011 15:17:32 -0500
Message-ID: <BANLkTi=9mp0v4kn+3ZZP7CtBxE88Ox3_rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking for a filesystem-level tool to perform something similar
to what badblocks does at the drive level.  I can certainly write it
on my own (I'd build it as a Perl or Python script), but if someone's
already invented this..

(The intended purpose is to validate that there are no quirks/bugs in
the overall fs.)
