From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: Really fucked up raid0 array
Date: Mon, 5 Jul 2004 12:11:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003901c462aa$af59d940$0201a8c0@windows>
References: <40E93DFC.6070507@pulz.no>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a long shot, but it's bitten me before.. If you log in, and then su
as root while your cwd is on the raid array, that bash shell will keep the
raid array busy. It backgrounds and hangs around while your su'd. Also,
mount has an option to remount read-only for cases where you can't unmount.
Not really sure where you could go from there, though.


