From: Neil Brown <neilb@suse.de>
Subject: RE: Scalability of MD raid 1  mirror devices
Date: Fri, 16 Oct 2015 13:29:12 +1100
Message-ID: <87mvvjwnpj.fsf@notabene.neil.brown.name>
References: <98ad0e44-1ac1-4451-a3d3-0a48f3a1d9e7@default> <a8179bae-f8e8-4239-b760-cd85252e48bc@default> <9b3ee99a-b29d-4e3f-8fba-a8346c3196ea@default> <87vba7vcqg.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vba7vcqg.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Ankur Bose <ankur.bose@oracle.com>, linux-raid@vger.kernel.org
Cc: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
List-Id: linux-raid.ids


Neil Brown <neilb@suse.de> writes:
>> So if the minor number is more than 511, the =E2=80=9Cfd=E2=80=9D is=
 assigned to -1,
>> if it is in the range of 0 to 511 It is working fine.
>
> Hmmm... you are right.
> Probably due to this:
>
> 	blk_register_region(MKDEV(MD_MAJOR, 0), 512, THIS_MODULE,
> 			    md_probe, NULL, NULL);
>
> Try changing the "512" to "1<<MINORBITS".

Actually don't change that.  That is deliberate.

add "CREATE named=3Dyes" to /etc/mdadm.conf, then create arrays
with names like
  /dev/md/whatever-you-like

and you can create as many as you like.

The arrays are create by effectively doing

  echo md_whatever-you-like > /sys/module/md_mod/parameters/new_array

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
