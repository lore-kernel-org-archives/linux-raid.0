From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: mdadm raid10 performance
Date: Mon, 2 Jun 2008 12:26:19 +0200
Message-ID: <20080602102619.GA30779@rap.rap.dk>
References: <b8f627e0806011347x49630976gf9bcf57d7356489b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b8f627e0806011347x49630976gf9bcf57d7356489b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: ???? ????????? <socketpair@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 02, 2008 at 02:47:53AM +0600, ???? ????????? wrote:
> Hello. I have a simple question.
> 
> I just created mdadm raid10 with four disks. The raid  build process
> complete successfully.
> All of 4 HDD are connected with separate SATA wires directly to motherboard.
> The mode of operation (selected in bios) neither AHCI nor RAID.
> 
> I decide to acheive performance information of software RAID.
> So I read 10 blocks by 64Mb. This give me roughly performance of one disk.
> (I expect that it will be 4x speed ! it should read from 4 hdd
> simultaneously!!!, BUT NOT! )
> 
> So, second test were reading 10 blocks (from 0 to 9) in one process,
> and 10 blocks (from 10 to 19) in second thread.
> I acheive performance of half disk... in each thread.
> 
> WTF? maybe raid is configured incorrectly ? Or my tests are invalid ?
> 
> Any ideas ?

have a look on the howto performance section.

http://linux-raid.osdl.org/index.php/Performance

the far layout is "far" better:-)

Also note the problem solving section there.

doing IO in more threads will have your array behave in random read
mode. 

What kernel are you running?

best regards
keld
