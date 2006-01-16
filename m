From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: md faster than h/w?
Date: Mon, 16 Jan 2006 14:31:22 +0800
Message-ID: <43CB3DBA.405@fastmail.co.uk>
References: <dq7jii$n1c$1@sea.gmane.org> <Pine.LNX.4.44.0601131720090.24299-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0601131720090.24299-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
> I've written a fairly
> simple bandwidth-reporting tool:
> 	http://www.sharcnet.ca/~hahn/iorate.c
> 
> it prints incremental bandwidth, which I find helpful because it shows
> recording zones, like this slightly odd Samsung:
> 	http://www.sharcnet.ca/~hahn/sp0812c.png
> 

Using iorate.c, I guess somewhat different numbers for the 2.6.15 kernel than
for the 2.6.8 kernel - the 2.6.15 kernel starts off at 105MB/s and head down
to 94MB/s, while 2.6.8 starts at 140MB/s and heads town to 128MB/s.

That seems like a significant difference to me?

What to do?

Max.

