From: Andrew Burgess <aab@cichlid.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 07:34:11 -0700
Message-ID: <1240065251.9039.3.camel@cichlid.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	 <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
	 <18899.61151.445765.360191@notabene.brown>
	 <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
	 <18919.64597.426128.498393@notabene.brown>
	 <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
	 <20090417183952.GA6090@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090417183952.GA6090@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2009-04-17 at 20:40 +0200, Piergiorgio Sartor wrote:
> 
> The problem is that when something is changed in the array,
> the file needs to be recreated.
> For example, this happened to me, after growing the array it
> was not possibile anymore to restart it without rerunning
> the "--examin --scan" thing.

That happened to me too but it was because I had the number of devices
in the file and that became incorrect when I grew the array. So I
removed everything except the UID and the name. All the other
information mdadm can glean from the devices themselves. The UID won't
change unless you completely obliterate the array.

