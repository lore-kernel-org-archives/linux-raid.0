From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Using the md driver to look at a bad hardware RAID.
Date: Tue, 01 Mar 2005 16:14:39 -0800
Message-ID: <4225056F.7040405@h3c.com>
References: <200503012354.j21Nspod001357@mint-square.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503012354.j21Nspod001357@mint-square.mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Omri Schwarz <ocschwar@MIT.EDU>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I posted a shell script a couple weeks back that 
creates/starts/stops/deletes a raid array from loopback mounted files

I mention that not because it helps you solve your problem directly, but 
its certainly a tool you could use to verify your commands, for instance 
if you made the files read only, and/or took md5sums to see if they were 
modified, etc.

Screwing up test files while learning beats destroying data any day

-Mike

Omri Schwarz wrote:

> 
> Instead, if I were to insert this raidtab, would it do the right thing?
> 
