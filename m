From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Call for RAID-6 users
Date: Tue, 27 Jul 2004 12:40:52 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0407271238490.25702-100000@sweetums.bluetronic.net>
References: <20040727021209.GA19205@jim.sh>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040727021209.GA19205@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 26 Jul 2004, Jim Paris wrote:
>tar handles special files in /dev properly.

Don't bet your life on it.  GNU Tar (tm) will work most of the time on
most systems (read: non-linux), but NEVER assume tar will read device
entries correctly. (cpio is the "correct" tool.  dump is the Correct
Tool (tm).)

--Ricky


