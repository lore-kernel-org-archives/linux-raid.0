From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: Input/Output error reading from a clean raid
Date: Mon, 23 Jan 2017 11:02:24 -0300
Message-ID: <CAGmni9pazRfia++-s5Hn4FT+ubVzEhsnrQrKC3cSLja53-SizQ@mail.gmail.com>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
 <20170123010334.GA7546@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170123010334.GA7546@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, i have run echo check >>/sys/block/md1/md/sync_action, and now the output of
mdadm mdadm --examine-badblocks /dev/sdd1 /dev/sdg1 /dev/sdf1  /dev/sde1

Bad-blocks on /dev/sdd1:
          1515723072 for 512 sectors
          1515723584 for 512 sectors
          1515724096 for 512 sectors
          1515724608 for 512 sectors
          1515725120 for 512 sectors
          1515725632 for 512 sectors
          1515726144 for 512 sectors
          1515726656 for 512 sectors
          1515727168 for 512 sectors
          1515727680 for 512 sectors
          1515728192 for 512 sectors
          1515728704 for 512 sectors
          1515729216 for 512 sectors
          1515729728 for 512 sectors
          1515730240 for 512 sectors
          1515730752 for 512 sectors
          1515731264 for 512 sectors
          1515731776 for 512 sectors
          1515732288 for 512 sectors
          1515732800 for 512 sectors
          1515733312 for 512 sectors
          1515733824 for 512 sectors
          1515734336 for 512 sectors
          1515734848 for 512 sectors
          1515735360 for 512 sectors
          1515735872 for 512 sectors
          1515736384 for 512 sectors
          1515736896 for 512 sectors
          1515737408 for 512 sectors
          1515737920 for 512 sectors
          1515738432 for 512 sectors
          1515738944 for 512 sectors
          1515739456 for 512 sectors
          1515739968 for 512 sectors
          1515740480 for 512 sectors
          1515740992 for 512 sectors
          1515741504 for 512 sectors
          1515742016 for 192 sectors
          1515743712 for 512 sectors
          1515744224 for 512 sectors
          1515744736 for 512 sectors
          1515745248 for 512 sectors
          1515745760 for 512 sectors
          1515746272 for 512 sectors
          1515746784 for 512 sectors
          1515747296 for 512 sectors
          1515747808 for 512 sectors
          1515748320 for 512 sectors
          1515749072 for 304 sectors
          1515750400 for 512 sectors
          1515750912 for 512 sectors
          1515751424 for 512 sectors
          1515751936 for 512 sectors
          1515752448 for 512 sectors
          1515752960 for 512 sectors
          1515753472 for 512 sectors
          1515753984 for 512 sectors
          1515754496 for 232 sectors
Bad-blocks list is empty in /dev/sdg1
Bad-blocks list is empty in /dev/sdf1
Bad-blocks on /dev/sde1:
          1515723072 for 512 sectors
          1515723584 for 512 sectors
          1515724096 for 512 sectors
          1515724608 for 512 sectors
          1515725120 for 512 sectors
          1515725632 for 512 sectors
          1515726144 for 512 sectors
          1515726656 for 512 sectors
          1515727168 for 512 sectors
          1515727680 for 512 sectors
          1515728192 for 512 sectors
          1515728704 for 512 sectors
          1515729216 for 512 sectors
          1515729728 for 512 sectors
          1515730240 for 512 sectors
          1515730752 for 512 sectors
          1515731264 for 512 sectors
          1515731776 for 512 sectors
          1515732288 for 512 sectors
          1515732800 for 512 sectors
          1515733312 for 512 sectors
          1515733824 for 512 sectors
          1515734336 for 512 sectors
          1515734848 for 512 sectors
          1515735360 for 512 sectors
          1515735872 for 512 sectors
          1515736384 for 512 sectors
          1515736896 for 512 sectors
          1515737408 for 512 sectors
          1515737920 for 512 sectors
          1515738432 for 512 sectors
          1515738944 for 512 sectors
          1515739456 for 512 sectors
          1515739968 for 512 sectors
          1515740480 for 512 sectors
          1515740992 for 512 sectors
          1515741504 for 512 sectors
          1515742016 for 192 sectors
          1515743712 for 512 sectors
          1515744224 for 512 sectors
          1515744736 for 512 sectors
          1515745248 for 512 sectors
          1515745760 for 512 sectors
          1515746272 for 512 sectors
          1515746784 for 512 sectors
          1515747296 for 512 sectors
          1515747808 for 512 sectors
          1515748320 for 512 sectors
          1515749072 for 304 sectors
          1515750400 for 512 sectors
          1515750912 for 512 sectors
          1515751424 for 512 sectors
          1515751936 for 512 sectors
          1515752448 for 512 sectors
          1515752960 for 512 sectors
          1515753472 for 512 sectors
          1515753984 for 512 sectors
          1515754496 for 232 sectors
[]'s
Salatiel


On Sun, Jan 22, 2017 at 10:03 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Sun, Jan 22, 2017 at 11:08:40AM -0300, Salatiel Filho wrote:
>> Any ideas what could it be ?
>
> mdadm --examine-badblocks
>
> Regards
> Andreas Klauer
