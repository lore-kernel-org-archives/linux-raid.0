From: "John Madden" <jmadden@ivytech.edu>
Subject: RE: md multipath restart problem
Date: Mon, 20 Jun 2005 09:41:56 -0500 (EST)
Message-ID: <47024.10.0.15.208.1119278516.squirrel@postal2>
References: <92952AEF1F064042B6EF2522E0EEF4376EE2F2@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <92952AEF1F064042B6EF2522E0EEF4376EE2F2@EXNA.corp.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Nagpure, Dinesh" <Dinesh.Nagpure@stratus.com>
Cc: linux-raid@vger.kernel.org, "Nagpure, Dinesh" <dinesh.nagpure@stratus.com>
List-Id: linux-raid.ids

> Have you found a solution to the problem? If not then which kernel version are you
> using. The problem you are talking about seems like a bug in md that got fixed
> recently.

And to think I was just about to give up and unsubscribe... :)

I did actually manage to fix the issue by just not doing things correctly -- if I
--build the array instead of starting it with -A, it works.  (See my previous
posts.) I'm running kernel 2.6.11.8 so far, what version has a/the fix?

Thanks,
  John




-- 
John Madden
UNIX Systems Engineer
Ivy Tech Community College of Indiana
jmadden@ivytech.edu

