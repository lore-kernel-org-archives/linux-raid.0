From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Failed during rebuild (raid5)
Date: Fri, 3 May 2013 18:29:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305031826270.24367@uplift.swm.pp.se>
References: <51839E4F.7050102@midgaard.us> <5183A1C7.5000905@mpstor.com> <20130503124023.GB27548@cthulhu.home.robinhill.me.uk> <20867.49429.400548.184315@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20867.49429.400548.184315@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 3 May 2013, John Stoffel wrote:

> We've got all these compute cycles kicking around that could be used to 
> make things even more reliable, we should be using them in some smart 
> way.

I would like to see mdadm tell the user that RAID5 is not a recommended 
raid level for component drives over 200 TB in size and recommend people 
to use RAID6, and ask for confirmation from the operator to go ahead and 
create RAID5 anyway if operator really wants that.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
