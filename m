From: Martin Cracauer <cracauer@cons.org>
Subject: Periodic RebuildStarted event
Date: Mon, 7 Feb 2011 18:44:11 -0500
Message-ID: <20110207234411.GA93362@cons.org>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com> <AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just got through the RebuildStarted event which seems to be
monthly.  This is being triggered by my Debian config, but before I
nuke it I'd like to know a little more.

If a real disk error happens during this rebuild on a raid5, would the
disk go into regular degraded mode or would it count as a double
fault?

I also noticed that recently all the checks for all the arrays happen
simultaneously.  That's bad because most of them share the same
physical disks.  Am I imagining this or was the system smart enough to
do them one after another until recently?

Do you do period checks? I get lots of device mismatches reported but
apparently that's normal if there's write activity.  The whole thing
sound contra-productive to me and might panic new users.

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
