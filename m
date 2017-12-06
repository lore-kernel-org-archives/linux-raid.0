From: Jeremy Graham <jeremy@doghouse.agency>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 6 Dec 2017 18:36:42 +1100
Message-ID: <CAGx2nv546O5v23Pc2BsWQ=G1xKqiZ66FCqN19MneL9d+YtavTA@mail.gmail.com>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru> <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Graham <jeremy@doghouse.agency>
Cc: Phil Turmel <philip@turmel.org>, 002@tut.by, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Minor update, badblocks reported no bad blocks:

$ badblocks -v /dev/sdb1 > sdb1.badsectors.txt
Checking blocks 0 to 2930265087
Checking for bad blocks (read-only test): done
Pass completed, 0 bad blocks found. (0/0/0 errors)

$ badblocks -v /dev/sdf1 > sdf1.badsectors.txt
Checking blocks 0 to 2930265087
Checking for bad blocks (read-only test): done
Pass completed, 0 bad blocks found. (0/0/0 errors)

$ badblocks -v /dev/sde1 > sde1.badsectors.txt
Checking blocks 0 to 2930265087
Checking for bad blocks (read-only test):
done
Pass completed, 0 bad blocks found. (0/0/0 errors)


However mdadm says otherwise

$ mdadm --examine-badblocks /dev/sd[bcdefg]1
Bad-blocks list is empty in /dev/sdb1
No bad-blocks list configured on /dev/sdc1
No bad-blocks list configured on /dev/sdd1
Bad-blocks on /dev/sde1:
              243656 for 368 sectors
            56643704 for 512 sectors
            56644216 for 248 sectors
            56874144 for 88 sectors
            93973944 for 288 sectors
           515436792 for 512 sectors
           515437304 for 64 sectors
           576966904 for 456 sectors
          1689261664 for 352 sectors
          1689262424 for 512 sectors
          1689262936 for 104 sectors
          2271200520 for 512 sectors
          2271201032 for 440 sectors
          2271214344 for 440 sectors
          2271221320 for 512 sectors
          2271221832 for 120 sectors
          2933440312 for 512 sectors
          2933440824 for 48 sectors
          2965096488 for 400 sectors
          2972488160 for 512 sectors
          2972488672 for 160 sectors
          4462680184 for 312 sectors
          4799622528 for 224 sectors
          4799623104 for 512 sectors
          4799623616 for 160 sectors
          4799626912 for 512 sectors
          4799627424 for 448 sectors
          4799631240 for 512 sectors
          4799631752 for 216 sectors
          4799633568 for 448 sectors
          4799635752 for 312 sectors
          4799638008 for 104 sectors
          4799655704 for 512 sectors
          4799656216 for 512 sectors
          4799656728 for 512 sectors
          4799657240 for 328 sectors
          4799657608 for 512 sectors
          4799658120 for 472 sectors
          4799658600 for 512 sectors
          4799659112 for 504 sectors
          4799659936 for 512 sectors
          4799660448 for 512 sectors
          4799660960 for 512 sectors
          4799661472 for 192 sectors
          4799662192 for 496 sectors
          4799662720 for 512 sectors
          4799663232 for 480 sectors
          4799664344 for 392 sectors
          4799664744 for 512 sectors
          4799665256 for 504 sectors
          4799666536 for 512 sectors
          4799667048 for 392 sectors
          4799667600 for 208 sectors
          4799668800 for 32 sectors
          4799668856 for 512 sectors
          4799669368 for 488 sectors
          4799670984 for 512 sectors
          4799671496 for 408 sectors
          4799671984 for 512 sectors
          4799672496 for 432 sectors
          4799673152 for 512 sectors
          4799673664 for 288 sectors
          4799673960 for 512 sectors
          4799674472 for 504 sectors
          4799675456 for 512 sectors
          4799675968 for 32 sectors
          4799676104 for 512 sectors
          4799676616 for 408 sectors
          4799677624 for 424 sectors
          4799678152 for 512 sectors
          4799678664 for 408 sectors
          4799679824 for 272 sectors
          4799680128 for 512 sectors
          4799680640 for 480 sectors
          4799682112 for 512 sectors
          4799682624 for 512 sectors
          4799684384 for 512 sectors
          4799684896 for 320 sectors
          4799686728 for 512 sectors
          4799687240 for 24 sectors
          4799687336 for 512 sectors
          4799687848 for 440 sectors
          4799721864 for 216 sectors
          4807365632 for 512 sectors
          4807366144 for 8 sectors
          4807562840 for 512 sectors
          4807563352 for 128 sectors
          4829237792 for 88 sectors
          4979524112 for 512 sectors
          4979524624 for 272 sectors
          4979574088 for 512 sectors
          4979574600 for 472 sectors
          4979630520 for 512 sectors
          4979631032 for 360 sectors
          5555126536 for 376 sectors
          5555143496 for 512 sectors
          5555144008 for 312 sectors
          5829752272 for 512 sectors
          5829752784 for 384 sectors
Bad-blocks on /dev/sdf1:
              243656 for 368 sectors
            56643704 for 512 sectors
            56644216 for 248 sectors
            56874144 for 88 sectors
            93973944 for 288 sectors
           515436792 for 512 sectors
           515437304 for 64 sectors
           576966904 for 456 sectors
          1689261664 for 352 sectors
          1689262424 for 512 sectors
          1689262936 for 104 sectors
          2271200520 for 512 sectors
          2271201032 for 440 sectors
          2271214344 for 440 sectors
          2271221320 for 512 sectors
          2271221832 for 120 sectors
          2933440312 for 512 sectors
          2933440824 for 48 sectors
          2965096488 for 400 sectors
          2972488160 for 512 sectors
          2972488672 for 160 sectors
          4462680184 for 312 sectors
          4799622528 for 224 sectors
          4799623104 for 512 sectors
          4799623616 for 160 sectors
          4799626912 for 512 sectors
          4799627424 for 448 sectors
          4799631240 for 512 sectors
          4799631752 for 216 sectors
          4799633568 for 448 sectors
          4799635752 for 312 sectors
          4799638008 for 104 sectors
          4799655704 for 512 sectors
          4799656216 for 512 sectors
          4799656728 for 512 sectors
          4799657240 for 328 sectors
          4799657608 for 512 sectors
          4799658120 for 472 sectors
          4799658600 for 512 sectors
          4799659112 for 504 sectors
          4799659936 for 512 sectors
          4799660448 for 512 sectors
          4799660960 for 512 sectors
          4799661472 for 192 sectors
          4799662192 for 496 sectors
          4799662720 for 512 sectors
          4799663232 for 480 sectors
          4799664344 for 392 sectors
          4799664744 for 512 sectors
          4799665256 for 504 sectors
          4799666536 for 512 sectors
          4799667048 for 392 sectors
          4799667600 for 208 sectors
          4799668800 for 32 sectors
          4799668856 for 512 sectors
          4799669368 for 488 sectors
          4799670984 for 512 sectors
          4799671496 for 408 sectors
          4799671984 for 512 sectors
          4799672496 for 432 sectors
          4799673152 for 512 sectors
          4799673664 for 288 sectors
          4799673960 for 512 sectors
          4799674472 for 504 sectors
          4799675456 for 512 sectors
          4799675968 for 32 sectors
          4799676104 for 512 sectors
          4799676616 for 408 sectors
          4799677624 for 424 sectors
          4799678152 for 512 sectors
          4799678664 for 408 sectors
          4799679824 for 272 sectors
          4799680128 for 512 sectors
          4799680640 for 480 sectors
          4799682112 for 512 sectors
          4799682624 for 512 sectors
          4799684384 for 512 sectors
          4799684896 for 320 sectors
          4799686728 for 512 sectors
          4799687240 for 24 sectors
          4799687336 for 512 sectors
          4799687848 for 440 sectors
          4799721864 for 216 sectors
          4807365632 for 512 sectors
          4807366144 for 8 sectors
          4807562840 for 512 sectors
          4807563352 for 128 sectors
          4829237792 for 88 sectors
          4979524112 for 512 sectors
          4979524624 for 272 sectors
          4979574088 for 512 sectors
          4979574600 for 472 sectors
          4979630520 for 512 sectors
          4979631032 for 360 sectors
          5555126536 for 376 sectors
          5555143496 for 512 sectors
          5555144008 for 312 sectors
          5829752272 for 512 sectors
          5829752784 for 384 sectors
No bad-blocks list configured on /dev/sdg1


I'm pretty sure the bad blocks are the result of a faulty SATA cable
about 2 years ago

As there are no badblocks on the devices themselves (only reported by
mdadm) would it be safe to try:
mdadm --assemble -v /dev/md0 /dev/sd[bcdefg]1 --update=no-bbl




> Thanks very much for the responses so far all!
>
> @Nix
>> That's a kernel bug, probably a deadlock. *Definitely* try a newer
>> kernel, 4.14.3 (the latest) if possible. I bet this is fixed by
>
> I tried updating the kernel, bumped to "4.12.5-041205-generic" first
> but still no dice.
>
> @002, @Phil
>> This feature generally shouldn't be used, because its implementation is
>> unfinished. Empty BBL's can be removed from every device by giving
>> "--update=no-bbl" option to mdadm on assemble, but before that you
>> must manually regenerate content for each block in BBL's and then
>> manually zero the lists in superblocks.
>
> I am currently running "badblocks -v /dev/sde1 > sde1.badsectors.txt"
> and "badblocks -v /dev/sdf1 > sdf1.badsectors.txt" to see what that
> comes back with.
>
> How do I "manually regenerate content for each block in BBL's and then
> manually zero the lists in superblocks"? This is uncharted (and
> slightly scary) territory for me.


end<div id="DAB4FAD8-2DD7-40BB-A1B8-4E2AA1F9FDF2"><br />
<table style="border-top: 1px solid #D3D4DE;">
	<tr>
        <td style="width: 55px; padding-top: 13px;"><a
href="http://www.avg.com/email-signature?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail"
target="_blank"><img
src="https://ipmcdn.avast.com/images/icons/icon-envelope-tick-green-avg-v1.png"
alt="" width="46" height="29" style="width: 46px; height: 29px;"
/></a></td>
		<td style="width: 470px; padding-top: 12px; color: #41424e;
font-size: 13px; font-family: Arial, Helvetica, sans-serif;
line-height: 18px;">Virus-free. <a
href="http://www.avg.com/email-signature?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail"
target="_blank" style="color: #4453ea;">www.avg.com</a>
		</td>
	</tr>
</table><a href="#DAB4FAD8-2DD7-40BB-A1B8-4E2AA1F9FDF2" width="1"
height="1"></a></div>
