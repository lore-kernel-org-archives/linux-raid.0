From: "Michael" <michael@insulin-pumpers.org>
Subject: Re: Partitioned raid and major number
Date: Thu, 26 Feb 2004 15:01:38 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402262301.i1QN1d228263@bzs.org>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

<snip>
> That's just a suggestion. Feel free to completely ignore it (as you
> probably will since dynamically allocated majors, initrd and udev
> are the future some people say ..)
> 
<snip>

Well.... :-(
Back at raid v 0.5x, initrd was the only way you could start and stop
root mounted raid and it was a huge pain in the butt. Modifying the
initrd file every time you must make a change to some little thing is
no fun at all. I for one am very fond of partition type "FD".

Michael
Michael@Insulin-Pumpers.org

Michael@Insulin-Pumpers.org
