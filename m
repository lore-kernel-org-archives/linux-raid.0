From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: kernel panic??
Date: Tue, 8 Mar 2005 04:41:04 +0100
Message-ID: <62b0912f050307194144c3ea8@mail.gmail.com>
References: <4225E09C.5010401@advocap.org> <42271B3D.1050000@advocap.org>
	 <422D079B.7050507@advocap.org>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <422D079B.7050507@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McMonagle wrote:
> All panics seem to be associated with accessing bad spot on sdb
> It seems really strange that one can get panic from a drive problem.

<sarcasm> Wow, yeah, never seen that happen with Linux before! </sarcasm>

Just for the fun of it, try digging up a disk which has a bad spot
somewhere, preferably track 0, otherwise point an extended partition
table to the bad spot.  Then try and get your linux box to even boot
with the disk in the system :-D.

God, Linux is so stable.. Bwahaha...
