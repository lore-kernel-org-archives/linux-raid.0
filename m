From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Subject: Re: PROBLEM: [RAID5 BUG] the reading rate after writing is lower than
 reading rate before writing in raid5.
Date: Thu, 26 Oct 2017 15:11:16 +0800
Message-ID: <CAOOPZo5g3r9trLTm8jZ79O7j3WzvsjE_wxSAuj4=UhF-8P4B2g@mail.gmail.com>
References: <FDBBB9A3A4FD244FAE380E1C59AE40D2028C7B22@ZXBJMBX01.zhaoxin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FDBBB9A3A4FD244FAE380E1C59AE40D2028C7B22@ZXBJMBX01.zhaoxin.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vic Wang <VicWang@zhaoxin.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
I have met the same problem as you, there is indeed a bug with the
variable referring to conf->empty_inactive_list_nr and I have sent a
patch to upstream to fix it:
    ff00d3b ("raid5: fix incorrectly counter of conf->empty_inactive_list_n=
r")
The patch was intergrated since release 4.8-rc4, so try it and it's
should be helpful.

Thanks,
Zhengyuan

2017-10-26 14:22 GMT+08:00 Vic Wang <VicWang@zhaoxin.com>:
> Hi Maintainer=EF=BC=9A
> =E3=80=80=E3=80=80Sorry to disturb you. I heard you are the maintainer of=
 RAID5 from NeilBrown.
> =E3=80=80=E3=80=80[1. ] I found the reading rate after writing is lower t=
han reading rate before writing .
> =E3=80=80=E3=80=80[2. ] The following is what I found about the performan=
ce of RAID5. It seems as a bug about RAID5. All of my experiments are based=
 on Kernel 3.16.4 Ubuntu 14.04.
>         First, I make a raid5 device using the COMMAND =E2=80=9Cmdadm =E2=
=80=93C /dev/md5 =E2=80=93l5 =E2=80=93n8 =E2=80=93assume-clean /dev/sd[bcde=
fghi]=E2=80=9D.
>         Then, using dd for the first reading: dd if=3D/dev/md5 of=3D/dev/=
null bs=3D1M count=3D30000. Record the reading rate as A .
>         Then, using dd for writing: dd if=3D/dev/zero of=3D/dev/md5 bs=3D=
1M count=3D30000.
>         Then, using dd for the second reading: dd if=3D/dev/md5 of=3D/dev=
/null bs=3D1M count=3D30000. Record the reading rate as B.
>          I found after writing the rate of B for the second reading is lo=
wer than A.
>
>          [3. ]The analysis is, when the first reading, the variable conf-=
>empty_inactive_list_nr in function md_raid5_congested is zero, then md_rai=
d5_congested will return zero and the readahead in reading is using page_ca=
che_async_readahead.
> =E3=80=80=E3=80=80Void page_cache_async_readahead(){
> =E3=80=80=E3=80=80         /*
> =E3=80=80=E3=80=80         * Defer asynchronous read-ahead on IO congesti=
on.
> =E3=80=80=E3=80=80         */
> =E3=80=80=E3=80=80         If(bdi_read_congested(mapping->backing_dev_inf=
o))
> =E3=80=80=E3=80=80                   Return;
> =E3=80=80=E3=80=80         /* do read-ahead */
> =E3=80=80=E3=80=80         ondemand_readahead(mapping, ra, filp, true, of=
fset, req_size);
> =E3=80=80=E3=80=80}
>          In Raid5, the bdi_read_congested will finally call md_raid5_cong=
ested.
>          But after writing, the variable conf->empty_inactive_list_nr is =
not zero, then for the second reading, when call page_cache_async_readahead=
, it will return at the bid_read_congested. It doesn=E2=80=99t do the real =
readahead and every read will be a page_cache_sync_readahead. So it results=
 that the second reading rate B is lower than the first reading A.
>
> =E3=80=80=E3=80=80[4. ]I think the variable conf->empty_inactive_list_nr =
should be balance after reading or writing. But the result is that it break=
 the balance(the value is not zero) after writing, and each writing will ma=
ke the variable conf->empty_inactive_list_nr bigger. But I don=E2=80=99t fi=
nd what makes the variable non-zero after writing. If you solve this proble=
m or have some discoveries, please let me know. Thank you very much.
>
>
> Best Regards!
> VicWang | Beijing,China
> +8618516890121
>
>
> =E4=BF=9D=E5=AF=86=E5=A3=B0=E6=98=8E=EF=BC=9A
> =E6=9C=AC=E9=82=AE=E4=BB=B6=E5=90=AB=E6=9C=89=E4=BF=9D=E5=AF=86=E6=88=96=
=E4=B8=93=E6=9C=89=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E4=BE=9B=E6=8C=87=E5=
=AE=9A=E6=94=B6=E4=BB=B6=E4=BA=BA=E4=BD=BF=E7=94=A8=E3=80=82=E4=B8=A5=E7=A6=
=81=E5=AF=B9=E6=9C=AC=E9=82=AE=E4=BB=B6=E6=88=96=E5=85=B6=E5=86=85=E5=AE=B9=
=E5=81=9A=E4=BB=BB=E4=BD=95=E6=9C=AA=E7=BB=8F=E6=8E=88=E6=9D=83=E7=9A=84=E6=
=9F=A5=E9=98=85=E3=80=81=E4=BD=BF=E7=94=A8=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=
=96=E8=BD=AC=E5=8F=91=E3=80=82
> CONFIDENTIAL NOTE:
> This email contains confidential or legally privileged information and is=
 for the sole use of its intended recipient. Any unauthorized review, use, =
copying or forwarding of this email or the content of this email is strictl=
y prohibited.
