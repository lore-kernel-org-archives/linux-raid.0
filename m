From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Convert raid5 to raid1?
Date: Thu, 10 Mar 2005 19:11:23 -0500
Message-ID: <4230E22B.6070206@steeleye.com>
References: <4230BE56.6090905@advocap.org> <4230D279.5090101@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4230D279.5090101@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: John McMonagle <johnm@advocap.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:
> John McMonagle wrote:

> I just wonder about the comment "considering the current state of 
> raid5". What might be wrong with raid5 currently? 

Perhaps he's referring to the possibility of undetectable data 
corruption that can occur with software raid5? Granted, there's a very 
small chance of it happening, but if your array becomes degraded (i.e., 
you lose a disk, which with the way md currently works, only takes one 
bad block) and then you have a server crash (or other unclean shutdown 
of your array), you likely will suffer data corruption.

See this for more details:

http://www.cs.helsinki.fi/linux/linux-kernel/2002-19/0906.html

--
Paul
