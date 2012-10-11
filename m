From: Chris Murphy <lists@colorremedies.com>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Wed, 10 Oct 2012 21:47:15 -0600
Message-ID: <86D3AC8E-9C07-40A2-A409-3561436AB2DE@colorremedies.com>
References: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com>,  <507561EB.1050308@hardwarefreak.com> <2012101110412757886112@meganovo.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012101110412757886112@meganovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 10, 2012, at 8:42 PM, hanguozhong wrote:
>=20
> I did not save the outputs of smartctl, but I remember that the =93RA=
W_VALUE=94=20
> of the attribute whose name was=93Current_Pending_Sector=94 of sdb wa=
s 1. Did that
> indicate that the drive was bad?

Just one sector is bad. But there are other attributes, maybe the disk =
isn't spinning up, maybe there are a lot of other read errors or uncorr=
ected ECC errors. So I think we need more data.

smartctl -A /dev/sdb


> If the drive was not bad, what is the best way to relocate
> these bad sectors to spare? I have been using the tool "HDD_Regenerat=
or" running in windows,
> which is too slow. Each relocation took dozens of hours. It takes a l=
ong time to find the bad sector.=20
> If you have any better idea, please let me know.

Bad sectors can be like mice. Chances are, you've got more than one. I =
would obliterate the disk with Secure Erase. It's faster than writing z=
eros with dd. But I question why normal usage isn't causing the sectors=
 to be reallocated and you continue to have errors. I personally would =
replace the disk, and get the array back to normal health, and then fut=
z with the misbehaving drive on a separate system - if this is an impor=
tant array.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
