From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Auto replace disk
Date: Thu, 9 Mar 2017 09:31:18 +0800
Message-ID: <87713f17-e078-5d90-07b4-fc1dbb963496@fnarfbargle.com>
References: <CAJH6TXgyOEE5A8TZVZy-db+tPD1QeHtnXXO3B-1vmKe4cAt6xA@mail.gmail.com>
 <58C04AC9.9070801@youngman.org.uk>
 <CAJH6TXjjjnQ3_OJ87Gv8Spsd=7BZ7RGrfCJ0kqeRXTQN_1Q3KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXjjjnQ3_OJ87Gv8Spsd=7BZ7RGrfCJ0kqeRXTQN_1Q3KQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/03/17 05:32, Gandalf Corvotempesta wrote:

> Why ? I've removed many, many, many disks before with no issue.
> Why removing a disk should bring the whole array down? This seems a bug to me.
> If a disk will crash, the effect is the same as removing from the slot
> and RAID is
> meant to protect against this kind of failures.

In general a good number of "help me my RAID is dead" requests that hit 
this list are due to not performing routine array or drive scrubs. So 
one drive dies, and one of the others has a previously unknown bad 
sector. When you put the new drive in, during the rebuild the bad sector 
is hit and the whole array comes tumbling down.

Doing a proactive replacement reduces the possibility of this occurring. 
Having said that, if your disk is dead then there's no other option 
anyway. Regular array scrubs go a long way to mitigating this risk, but 
it does happen frequently enough that you need to be warned against it.

Just because it hasn't happened to you *yet* does not mean you're 
immune, and it's certainly not a *bug*.



