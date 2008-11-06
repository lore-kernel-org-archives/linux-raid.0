From: "Leandro Tracchia" <ltracchia@gmail.com>
Subject: Re: metadata format 00.90 unknown, ignored
Date: Thu, 6 Nov 2008 16:15:39 -0500
Message-ID: <837a927a0811061315v16217474q4afa56937f172fa9@mail.gmail.com>
References: <837a927a0811061051heb9081fr51217068eede302e@mail.gmail.com>
	 <49133ED8.4010409@rabbit.us>
	 <837a927a0811061113t45d06a43m7a877d116fae735d@mail.gmail.com>
	 <837a927a0811061213h5e2fa072s48986aab00d6e904@mail.gmail.com>
	 <20081106203729.GA27449@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081106203729.GA27449@cthulhu.home.robinhill.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

wiping the superblocks! yes, that was it. thanks!

On Thu, Nov 6, 2008 at 3:37 PM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Thu Nov 06, 2008 at 03:13:41PM -0500, Leandro Tracchia wrote:
>
>> ok, i want to start from scratch with these two hard drives. i quickly
>> learned formatting and removing them won't work. as soon as i put them
>> back in, mdadm starts rebuilding them. what do i need to do to be able
>> to create a new array with these two hard drives, if they are already
>> part of an apparently existing array???
>>
> You'll need to wipe the superblocks:
>    mdadm --zero-superblock /dev/sda
>    mdadm --zero-superblock /dev/sdc
>
> Then recheck the partitioning is still okay before continuing to create
> the new array on the partitions.
>
> Cheers,
>    Robin
> --
>     ___
>    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>   / / )      | Little Jim says ....                            |
>  // !!       |      "He fallen in de water !!"                 |
>
