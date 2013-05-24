From: Robert Goliasz <r.goliasz@digital-science.com>
Subject: Re: Attempt to change raid1 to raid0 results in division error in
 kernel
Date: Fri, 24 May 2013 10:39:40 +0100
Message-ID: <20130524093940.GA6493@gbl-macbook>
References: <20130523104400.GA827@gbl-macbook>
 <519EC4FD.1090800@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b624d7415104004dd739412
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519EC4FD.1090800@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--047d7b624d7415104004dd739412
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline

Hi Stan,

Thanks for your reply.

The point of my thread was to point out that a userland tool shouldn't
be able to cause a kernel to crash. It also shouldn't segfault when given
incorrect arguments.

If conversion from raid1 to raid0 is supported but I didn't specify
the right arguments, I should get an appropriate error message. If it's
not supported, then I should also get an appropriate error message.
My machine shouldn't crash because of me giving wrong arguments to mdadm.

Another, smaller, issue is that if conversion from raid 1 to raid 0 is
not supported then perhaps the mdadm manpage should be clearer about it,
rather saying "Currently supported growth options [...] [are] changing the
RAID level between 0, 1, 5, and 6"

>>   gbl-macbook# mdadm --grow /dev/md0 -l 0
>If it is possible, this command line won't work because you didn't
>specify a chunk size for the RAID0 stripe.  Every striped array type
>requires a chunk size.

This doesn't seem to be correct, I'm able to at least create a RAID0 stripe
without specifying the chunk size explicitly:

  root@gbl-macbook:~# mdadm --create /dev/md1 -l 0 -n 2 /dev/vg0/v1 /dev/vg0/v2
  mdadm: /dev/vg0/v1 appears to be part of a raid array:
      level=raid1 devices=3 ctime=Thu May 23 11:13:33 2013
  Continue creating array? y
  mdadm: Defaulting to version 1.2 metadata
  mdadm: array /dev/md1 started.
  root@gbl-macbook:~# cat /proc/mdstat 
  Personalities : [raid0] 
  md1 : active raid0 dm-4[1] dm-3[0]
        203776 blocks super 1.2 512k chunks
        
  unused devices: <none>
  root@gbl-macbook:~# 


>> Afterwards, my mounted filesystem (/dev/md0) disappeared (it's no longer
>> mounted), and all operations related to software raid seem to fail:
>Well of course.  Experimenting with mdadm without knowing what you're
>doing will often result in lost/corrupted arrays and other forms of damage.

I knew exactly what I was doing. I was testing whether conversion from raid1
to raid0 was supported. I got an unexpected result in the form of a kernel
crash. After discussing on IRC I was asked to report this here.

I've concluded that it's not supported or broken and will not attempt to run
this on a production machine.

-- 
Robert Goliasz
Infrastructure Engineer

-- 
******************************************************************************** 
  
DISCLAIMER: This e-mail is confidential and should not be used by anyone 
who is
not the original intended recipient. If you have received this e-mail in 
error
please inform the sender and delete it from your mailbox or any other 
storage
mechanism. Neither Macmillan Publishers Limited nor any of its agents accept
liability for any statements made which are clearly the sender's own and not
expressly made on behalf of Macmillan Publishers Limited or one of its 
agents.
Please note that neither Macmillan Publishers Limited nor any of its agents
accept any responsibility for viruses that may be contained in this e-mail 
or
its attachments and it is your responsibility to scan the e-mail and 
attachments (if any). No contracts may be concluded on behalf of Macmillan 
Publishers Limited or its agents by means of e-mail communication. 
Macmillan 
Publishers Limited Registered in England and Wales with registered number 
785998 
Registered Office Brunel Road, Houndmills, Basingstoke RG21 6XS   
********************************************************************************


--047d7b624d7415104004dd739412
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iF4EAREIAAYFAlGfNVwACgkQd2qCTldmJRcjcAD8D5DCggv/O3I+Y9bb6MGav/Pu
r6XnMKrI9BwCZCsX0hEA/ja81BKUnzI1cw5ctPrtDIz2hi6b+OORJVAzQWWf7qrI
=2d3Y
-----END PGP SIGNATURE-----

--047d7b624d7415104004dd739412--
