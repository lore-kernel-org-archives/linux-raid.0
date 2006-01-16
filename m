From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Expanding RAID array?
Date: Mon, 16 Jan 2006 22:48:04 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601162244220.1836@lion.drogon.net>
References: <1137424449.3953.38.camel@kenny> <17356.8228.325002.652805@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17356.8228.325002.652805@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 Jan 2006, Neil Brown wrote:

> - status of RAID6
>     I believe it is as stable/reliable as raid5.

FWIW: I've been using RAID-6 since early last year in production
environments and so-far so good. Kernels 2.6.11 to 2.6.15 (on a Dell 2850
server I'm building tonight with 6 drives). I did have some early issues
with it, but it was actually due to "intersting" hardware... I've not had
a disk failure for real yet, but it's "just worked" every time I've done
tests on it.

Gordon
