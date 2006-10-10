From: Eli Stair <estair@ilm.com>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Tue, 10 Oct 2006 13:42:23 -0700
Message-ID: <452C05AF.2070807@ilm.com>
References: <20061005171233.6542.patches@notabene><1061005071326.6578@suse.de><45255C54.6060608@ilm.com><4526DBCE.6070906@ilm.com> <17706.65210.999441.373846@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040703060205080909080801"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17706.65210.999441.373846@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040703060205080909080801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Thanks Neil,

I just gave this patched module a shot on four systems.  So far, I 
haven't seen the device number inappropriately increment, though as per 
  a mail I sent a short while ago that seemed remedied by using the 1.2 
superblock, for some reason.  However, it appears to have introduced a 
new issue, and another is unresolved by it:



// BUG 1
The single-command syntax to fail and remove a drive is still failing, I 
do not know if this is somehow contributing to the further (new) issues 
below:

   [root@gtmp06 tmp]# mdadm /dev/md0 --fail /dev/dm-0 --remove /dev/dm-0
   mdadm: set /dev/dm-0 faulty in /dev/md0
   mdadm: hot remove failed for /dev/dm-0: Device or resource busy

   [root@gtmp06 tmp]# mdadm /dev/md0 --remove /dev/dm-0
   mdadm: hot removed /dev/dm-0


// BUG 2
Now, upon adding or re-adding a "fail...remove"'d drive, it is not used 
for resync.  I realized previously that added drives weren't re-synced 
until the existing array build was done, then they were grabbed.  This 
however is a clean/active array that is rejecting the drive.

I've performed this identically on both a clean & active array, as well 
as a newly-created (resync'ing) array, to the same effect.  Even after 
rebuild or reboot, the removed drive isn't taken back and remains listed 
as a "faulty spare", with dmesg indicating that it is "non-fresh".




// DMESG:

md: kicking non-fresh dm-0 from array!


// ARRAY status 'mdadm -D /dev/md0'

           State : active, degraded
  Active Devices : 13
Working Devices : 13
  Failed Devices : 1
   Spare Devices : 0

          Layout : near=1, offset=2
      Chunk Size : 512K

            Name : 0
            UUID : 05c2faf4:facfcad3:ba33b140:100f428a
          Events : 22

     Number   Major   Minor   RaidDevice State
        0     253        1        0      active sync   /dev/dm-1
        1     253        2        1      active sync   /dev/dm-2
        2     253        5        2      active sync   /dev/dm-5
        3     253        4        3      active sync   /dev/dm-4
        4     253        6        4      active sync   /dev/dm-6
        5     253        3        5      active sync   /dev/dm-3
        6     253       13        6      active sync   /dev/dm-13
        7       0        0        7      removed
        8     253        7        8      active sync   /dev/dm-7
        9     253        8        9      active sync   /dev/dm-8
       10     253        9       10      active sync   /dev/dm-9
       11     253       11       11      active sync   /dev/dm-11
       12     253       10       12      active sync   /dev/dm-10
       13     253       12       13      active sync   /dev/dm-12

        7     253        0        -      faulty spare   /dev/dm-0




Let me know what more I can do to help track this down.  I'm reverting 
this patch, since it is behaving less-well than before.  Will be happy 
to try others.

Attached are typescript of the drive remove/add sessions and all output.


/eli


Neil Brown wrote:
> On Friday October 6, estair@ilm.com wrote:
>  >
>  > This patch has resolved the immediate issue I was having on 2.6.18 with
>  > RAID10.  Previous to this change, after removing a device from the array
>  > (with mdadm --remove), physically pulling the device and
>  > changing/re-inserting, the "Number" of the new device would be
>  > incremented on top of the highest-present device in the array.  Now, it
>  > resumes its previous place.
>  >
>  > Does this look to be 'correct' output for a 14-drive array, which dev 8
>  > was failed/removed from then "add"'ed?  I'm trying to determine why the
>  > device doesn't get pulled back into the active configuration and
>  > re-synced.  Any comments?
> 
> Does this patch help?
> 
> 
> 
> Fix count of degraded drives in raid10.
> 
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/raid10.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
> --- .prev/drivers/md/raid10.c   2006-10-09 14:18:00.000000000 +1000
> +++ ./drivers/md/raid10.c       2006-10-05 20:10:07.000000000 +1000
> @@ -2079,7 +2079,7 @@ static int run(mddev_t *mddev)
>                 disk = conf->mirrors + i;
> 
>                 if (!disk->rdev ||
> -                   !test_bit(In_sync, &rdev->flags)) {
> +                   !test_bit(In_sync, &disk->rdev->flags)) {
>                         disk->head_position = 0;
>                         mddev->degraded++;
>                 }
> 
> 
> NeilBrown
> 


--------------040703060205080909080801
Content-Type: application/x-gzip; x-mac-type="0"; x-mac-creator="0";
 name*0="gtmp-mdadm-add-drive-after-boot-to-degraded-array-fails-to-resyn";
 name*1="c.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="gtmp-mdadm-add-drive-after-boot-to-degraded-array-fails-to-r";
 filename*1="esync.log.gz"

H4sICBcCLEUAA2d0bXAtbWRhZG0tYWRkLWRyaXZlLWFmdGVyLWJvb3QtdG8tZGVncmFkZWQt
YXJyYXktZmFpbHMtdG8tcmVzeW5jLmxvZwDtWW1v2zYQ/loI6C/Ilxv2JQFim9SLX4S2WNM0
RZGmC+ZkG6AFBSNSjmpLMijaq4v9+B1JyZHUuAPaYBgwC7FJ3t1zJO9Od4d4Gst0qaBUTCrB
ocjhaiWAEvg5VuASMgRCQzoMKYXLC7g8vXIOPsiiUD/NVLYkfji4KzIxEIhP5QBJB39EDTbg
982P8C2YjPEnB9G5/nDGM+idwoCL9SDjxKknoQPV86uQZYqHD/G4feL2iYesV1IwpalXaSaQ
dYFTfS2YgL7RMPR8c0Wr5ReWcngn1mKBohIXlFjGSynZBqbpZ62DEuINXeIFLhxOglGfevAm
PUGyO+qPKLw5OTKgU7FOY1GD3PFw5OMHMdQb9kcVxh/2x24NMdtbWKn38ZF4VSi2aBI951KK
REiJrrpI80LqC5sNL7UBSiXyWG84XS2FvF0U8RzSEpY1Tzko+zbXMzhJVcaWKKvXMmcLx+i5
XnKmRG0xHQvaYhgP1AsJ/gUNi5lnqrR8CCxW6VocAxczybjgDrw0lPbxfyvkPM1nbSKcsXQh
mrfXd5oumRQt2v2u79imWCkk5oLJ5/QYiiQphXruWpFXd6t8Xhs/oO55Awrwnpm7kSbt+vrt
qaYFsZuwxA8TFicx4154yzzvlvokRMcnvjtm96jXa7SjPpnrWv3vV9mtkDi5YB8LMxoXWd/W
EaHNVesg5tsNvFolhRanMiqUmzzGlQl7nvWo0xJv4N2OoofxrtMSb+CDjqKH8UGN97p4H1qc
HXjfaYk38MOOoofx2/ALuvjuRR7GezV+2MHT7kF22H+rYFSNBLqTiiNFVqz1y2CfcffAtYKK
s2PDUY2fdPFjaHF24McVnn4RcBNocXbgJzW+G3CUdiY7DFZHLO1GXL1vzdmloH5ZaTfkatzW
dzsUuN9Sg2KmYLCURYzFBiUVODrNFpgsU5WapBTZQnEDDpajbRasygfojSNkmgNE1LMzElHX
zmhEqZlNImrFxtHEjKNobEW8aGgmXhSYcRj5ZvQjqy2IrC5Uf7P18rZEmRJQQqnLAdC+a5Ih
xDo9lviO26zZi4ulvk1E/YE+Y3Rtnw92qNXemoKBOXLgw5LNNICcn9wco+UpGbnnJ1av46zy
VYnZnNvMHcKzvMjFi3+tbzDdQt0hQK/HON+GAXEMG/3EsUQ1yI++0dOnD0AOMAYuHyGoSDS6
OTw72sfXd8bXF6540n0ezck7NO+7WkP8f3S1dN/Vfq1E77va5nH3XS3su9p/7mrbPmvYYOuz
nh0StlqoDZQm/8D3tT48E+UM/gIUWkAv0F1ViPU758+0WV+0lpR21qSzdtvrLtsu52lsMiyW
+l4iRXln2iBIZJEB05XsByO2yjtqxKdlIdUHibc91NQjQ606qeW279pgSM90MdElKMHstjAV
Ex1kRS0EMBmDbgMqb/yZqjvtIZ20iwTrWN2T6L4trBoaSHPs63CTz1q1Pi9PyzkqFIwDHVDb
6xwb3URj9BzT6arUyTzWxR6Bla7DqjU6Moe0u+kTOb+fTSErVrnSRkqw7pQbvE1meK9zrqnx
QrActoJGw71kaETnH4uVrprc/kMQYX2sO0WWpQrvgeZZY+UO8KxxkfPysXbtuP8RAnLfbO2b
rX2z9bXKsW+2msfdN1uwb7b+o82W+JQqx3w5U/tjHS9yseuXunHokfqXur8BTEG9jtwbAAA=
--------------040703060205080909080801
Content-Type: application/x-gzip; x-mac-type="0"; x-mac-creator="0";
 name*0="gtmp-mdadm-remove-drive-from-activeclean-array-add-fails.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="gtmp-mdadm-remove-drive-from-activeclean-array-add-fails.log";
 filename*1=".gz"

H4sICFwELEUAA2d0bXAtbWRhZG0tcmVtb3ZlLWRyaXZlLWZyb20tYWN0aXZlY2xlYW4tYXJy
YXktYWRkLWZhaWxzLmxvZwDsXW1z4kiS/rqniPkF8yVvZy4OzxmhkoR42fXEYLDdnI3NAe7d
Da7DIaTCaA2SRhLu9sT9+MuskgQI7O556ZfZETENoiozqyorK5+nSho8jYIg+eE+WYWaCfj+
5htYuba7gmoPai5/rK1cTcku2gqkr9c8ir3AhzZoTNV0VTOwqhtxO6HSibfiWDXAyxsnAWgB
s9r4n2GCrmmWtDKyPReu+CNfomiEX5gmKzpRZD/B2PuJbDBNMyxdM+o6VFr1hsoMuPBOsVhv
qA0GF6dHQqnHHz2HZ0p602qY+A91mGGpjVTHtNSmnqmI5qVaTO2YWDgJEnu5WziM+JxHEXdh
4PlBRAMWDQ7JAXHCfYcaHK9DHs2WgfMAXgxhVpcoKNv36QpOvWRlhyhL3yPfXirCzm3o2gnP
PDZZc+ExpgHT22azbbAtj4nXOCH5NthO4j1yBTric7fTfwuiB8+/Lwzv3PaWfHvMNJJxaEd8
p2zT1pX9FKwTLPS5HZ2wYwjm85gnJ7oU6S7W/kPm8jrTL7dUAa5tMSJtu+z2tt+jsrqjz+25
2Z7bztyxXaM9sw1jxkytjdM9N/WmvdE6e0TvUc+a0vz1ejXjEV4M7H8G4lPMi5zQLAzIR5kJ
TbzrdSP9zrKLtCb1JMRPvoPfRKy7qyozMgOsYAB02Kl5xoCu7Ihv6bOCoWc6kOkbRf0W7NQ8
o9/K9M2ivlm4OKxvZvr1or4FOzXP6OdBaxX0mVYw9Mz489BpFDuQG2i8ZCDXbxb1m4WLw/rN
TL9V1K/DTs0z+nVlZ7xb+kVPHNbPApAVA5BlAcheDECWRSDbi8BGwdJhA41MvxiBWbv5Wnqm
A0yZ7sOLYydQC6PAQUSJcaGCQrk0wIzoJZ7IQVOJBm9AQczJU12KESDW5hRrRQtTZoirxpTp
skifMiaujCmTUvVpS3w2p03xqU0bUlSbWuLCmtbFpzk1xWdrKo2yqbSJJt/kk5njkcj3McSU
+4GpusiB4FBWjHFpy2RZdYKQRjVlZo2h9entziszOxPogKmxZkJo35OCdnn65hg9zLSGfnkq
7SrK2l/HmMRdmbDb8Fc/8Pn3h/wsYTyDbqhW55j/N4sDCyK+CtCvm/UiVNqA3d6Sm9vrZfIE
nr/hA6ncIkhA2nC3jPwmXfnqqwNmvp4axvDzh88nDxtjEzZ3Hz1s9vz7p+Lro87mM62VbBQL
jc/KRutESF9mo8cYYPeR7XL3EC81DvFS43fPSxFmS2IqX39MYrrFR4vENEXHkojuyH8hRHQP
Wfaw52Ng4Z++nl5+7n+26+6zPiz82Txux9Cec9LX10iyhiWAf/bjpE8H4KwE8JeyUQngqVQJ
4CWAw07N8wD+/sPAqvxIzytikX/gQwDtMAUoYa6EuRLmoIS5EuZKmPuDwxxi2w8RvXF6q2Zb
xq7t+0ECQcj9jWI7gxVMKhGPg3WE17N1/PRBO8qI73bj4NGx1MKuWMOPg917AuU5dYn/Jf7v
5rAS/0v8L/H/Xwj/f+fY+6/0qMPejH09vfzjEorPfOPbaBtWeeM7e20IhVkSivRVEgrYrSkJ
xZdCKH45HfjtkOvD6MavuRH9K6jLHxdWP/M+/ZPB6u9sn17CaqZWwirs1pSw+qXA6kfZpx8q
q/HEqXm+l6hubYWmvNBOFi78nMe9Vu4qQAOYPLZL5fH8dglurqPkgwhDiZklZpaYKRSK67/E
zJ2aEjNLzPyomLleBWtMprVHO6pRRU2RJe2tIsxSQQKiGAPhEMAVbXyAzIFz7B/Wh7adez0s
7x2X+Fri64vJosTXVKrE1xJfYafmM+Br4gv0+jD4fX7/ON67rRonQRhmh71U/rxyZ085P/5d
2DHMOPdBbGDR3FsvWZC73AgdFUOFMmkwxyx2pJbb2y/5TqvZ1uvlndbstYHf8rdvMrUSfmG3
poTfLwV+n0cWOlwtb3x+OSj3mTeZnwzlfmebzBLlMrUS5WC3pkS5LwXlPsom89eUOYSu7orH
9/B/kNAzS9W6lv/MBoFrG9b+zPPdv1Lz34sC/i4MouQuwk5VqPSoIMaMg3LM2BNkhwVZUbBx
UK6xZ08/bE8vCh7u4F7/6gfF6kWx5kGx5l7vDruP7fnPOihnFcXMg2JmUax1UKy117vDnSuK
HfZw6mBiVemphCoKClqFtgo9LIyr4I2iFwvOL0xZYaKLAVKIq2I8FuK9GNcPniMIhB/41XnE
44X4XUSYR8EKbCJq//6h60ZSPEn1xOP05ME0e2TnMPn5S/YDdPTLfO301+uAHm7w7CXSDFd2
wPXiBzTIbRdYjckftjsWtjXSoWuE/3VM5MMhcoqKqa1K+jt4RzBHyiBbA3lmtOOTA3mkmELK
mzQlfy7580tkoOTPqVTJn0v+DDs1n5g/7zwkmD/tJ5/nG9M7Jbu8og1fTy3tYgr4qf3F0Fc3
l+KitQJ489ULdb+Gpgt4VU6xHDO7DcEDVJxgtbJ9F5aezwkg+tfn42Fn8uqkFtt+LX77tjZD
8RoRgbeRl/Cas1wjfkTz2HlQu2fXk5uxqb6zTPVRVxMeJ9B/dTOenPevzk6E5p23Ii5Q6486
g/Nx7ey6dzOqDvojdRHEmDH73fOLE+G05+1Cfzx6feIunBD6Z5NXvbPXJzxZaOCFsvD05mZy
1x90LrDJB8Qvvrwji3Ht8mx0fXY1ro1enV3VHlc4xPVPVV21VNa8e665I+UKxd7BY8oi3iOO
vasIP9tuFHjJEVTuHSdXNlRTFSiJwKMxqIwQ2V7ZiSxHtnsE37RgPBgWwBXpCILrsDeRAHva
vxlXwyh49OhoMlw8xZ6DXAAdCvTDwwoIAd7Ukc5phRcG8ta3lm1iUWUd27MlP3pOUUrtKNrC
VgVJKo8whT2r6u61ybQPU2XF7s7mc0uqvtTdXGpHsaELxU532AeK9Gd1peCOblPb6F6/Hj+r
2iw062Qef89Q59wpDlUUmR+iyvdVuXDde1X3OsyyqveobuRyVd3MVbO56Q36EJIdP1EV8l0b
RuPeECqPKA7DydWkB+97HcEPoL3TNq95o2FpqbW/j3E5kDWWWfs3WQakY2miS8gGJ8MtG7sW
KVbmzHZSi+ed1KIBnYHo3avOYHA22rU4nJx1pQ2kfOa+xQab1c3U4njUyfr4gkVRldtgByxy
xEhp8dXwrDBqKpmcXr0w6kMW51pmcdDZ92Nn2O/+PD+iRcPORj3sjnYtfnvbHWEfv93149V7
Rj2fZXPd28w1Oqt6iXwIP8WK3LI4GJ9P6LsMUL4XPeKl0Jy0Yfj3AWJ79Xs5VHF1HbgctutZ
Xs/yepbWS+HUjFa1t0wXqpzdhgu1zDxQzdLm88pqvsCU69tBpw23MXEHQxMb6mTB6WmLBcQL
b46rjeB8xVe0N1+H4MsGi36oZo7PLR9QY1CUytQ2HbrxsyYS2pGKjT5thfUmbnuRV/UGHfgp
8DmW1Rv5ucFV//wGZnbiLNqaFDL0VKxhNZot64CgQVuL6yBaIdZJUb3erFvaYdGsX6zQL4NW
bdFQWnzYkozB4aBKG98I+jcwDKIE8+E7zKDNtPoqIAgW0WK7Lia+GOuz/JzJiOqK7YTenedO
KTjfwNIOPWfzlfuUPzHzDqMA97Yxzu83yAHq7bo0njEJZj1rlO0aZYeNsvcavbvGHF7o7cK7
XwB37znxwwQL2ZujF3XYizr9G9l7Kau/yXw3Jd/JlfMG7mPvbmbHfKqhntTAyzakYwT9eDOA
xvGO+6WJY7gYY6ao6sbBZo2dZtP1utWsbm7aZVvtGs+2m9qQ7epmFRfCoYbNYsOs0HBz07C+
1bD5UsNs03Czmkdv/3pyNx51725eY2qerWM6tFvHd170I17dL4OZvRRf9M1s5XM0+h8NxB+q
mD0B7lejCGmnuqnUX6psHagc80RsfYQromAtviQBzJd2sg1znktrDDOJjvTDAHJJW8yqKxeV
TIICBSqEYvJ4kdizE/hz734dyRM+z5/TWqdrpbNc4kIVLQ67/fyn0GK5LaNiZONOmtyQu9Pf
8cgyeNtI4+lIOV17ywRkxlp6uG9RswO5NM/omqXrVkO5FNsP2N5Utf/wWyqlnx0uk8O7w9tv
NGXY70kQSyhVYcZKIo8caWqIBZUgcnlEv5Z1DIbesJoYUOiIIyXBjKw6GR4yUzVYkzWRCrz6
Cf7WubqSgXQxuenJK5KP1FytxxPu0EG1rmt11WzWhWKYJUlV6QZ+HCxxypxgiYECry86/wVN
7Z1eV3rUxSdwbCeD30LPmYYGG1udZ8fQNJpNS8u73yeEqj5voq6berO5sYAL22Qt08D9e2qh
u+DynoEd8ihZR1xVsdfDW9DaeRHxIIjpwBMxdnCqXAfQuRjCDFcj5uR5sPZd5R80OuL64AY8
9v8zgSW3HznYGyvIDQIc8AL9oQyxNuYprggC0r8ZDG4hCNMVJ8qEPUEnlMnCi9GJFI5PwRos
EztCdx8wYpWBHYbbQxCpAqx63bDgMpPCQTRTxjEQHWlDkzW0pm4+1NAjDdY0H8B+tL2l6FJF
r1utB3jIlp/Lj0FnVsOwHiDb3RxjwDRRiDaE6FirhXUU1OhVjM1ZJNOEy5f2E2YxkaQEAYhD
7nhzz0lzF7ocTJNZat2C0+A+GPSHY6gsw3+eNJuGwXR2pAzocdwX5hk7S5OGGMqgD12Sa6OP
LqFipTNdo8xxdAy9NOAOVKYW9EwfE+dhIdBq24T3POKcBkeJ016K8346JaNuNR9gjrVumpW7
AU5OxB89eRCiIfNuaI00Dy83BEi6yaN7B9E6xOSooMvXmDCZXjcYs2jxpAuP6SoWiWW3UZUU
lozmSxFYTU+5+ju2nz/YL5oyTWVsb8p0TTeso085HXQ7bbO/oN3gTYiuC/xKsjqCDWXTzSbC
FJeLRbOlLm63nnyHSibjLqGomGA1q6SjzgWaEvfxSELc/RMyOGAbscT15nM6YHWenCVx35X9
DqcNM1UjLUK0Q6/dLxLAbYFOurFCKERtEtt7SzzZDe4BUw/cXKrKyruXyHtHC/7EbDSU6zPc
24z4Pd1povtTOK9JgDkV5vbKWz5tiCdRk+Qp5BA6HoZapqAgWGdZfhfchXDOcijkwgiDK8o4
b1ojVVP6RTQhj86MgWQ0H1nBCKMPTmV6nGIBcrKKIAAE/aInOCmzjEMs7Mh9S8fBklcROyB9
OpwLspudXgzSAGtrlqpttdXP+3Hl+Q8wvbq+7GBzSJ1iMKAuDgBxc/wdpn7XE2crrvqy+ulG
/btM/2WN7naD332IRq/Qxe+e0xil9G4iEt70f+/Gp3cquVSdDPWhejccTd78TMULbdj5pYqn
meKgRyxidH2BMyRTkTLuImeO17P4CWNutX0DfDv6BN2kAMLh56Ej6vtzRMt0vjMQfRtED8dA
POHPGNAnJM+RZv8Z6SKKewks+DLERRfiQkHtiNONfGUR8oTwO4HBAHebG8oLlUcPIRLzLJbl
r/qcdpmYjcSMIEVqHmNaT40YCPrVGbYkEmFMmJdypFc/Ub+rPTpP6InQEuO7GKqb8hySiXxv
IFiyiQyhN+Iy5V50RhPJB7YsjQToUrVlSuiXjAEXjp3xBWIlWYvSp3IRttPFo8nFA7QFf+v5
bvCWiDYdj6AXsHhwNsjL5448BqrOXeklrB+Ozs7PJt1XuZBjWlIIL6TQ4VbtYqsGKRkHWuXp
MQlevNCqlrVaf6nVWbFV0quah1rNxsrZC602slabUuh9SVlX+kMR4vwFlqtbOjPNnKK2kGZp
rQajP6koGeqkOwRECwqveIGtfICRAzyXrNCTIgfVZSBm2hj9GfXeKOOWMleMcwjB7lS2+5b2
QzQkjMqGI+4H22D0+nwslswD/LjGTV8MLn3eIQNUmdKj65c4PWKt7CrQMGl7k+8GtllN9BQm
AQJpuEDagrCleAHEaNRdL1HVD4Jwu0s7lbafeA79JAnx9Y0QVFwu7l8e7Yq7uO8Ud/ues+fM
f9zD4gEmyx/XXvSQJ1CVEvHd6e347vyqczG+u765IyF6QojyJWZWHLXn0xMhCJTqb2UG8+rd
IkjC5fpeQsErBN8hfhNfBGVND0twaal1ZcQxfYpHWLriGZge/e9oETwylem2g5sjv/oYLJFc
LPMtj5uL6OnNQPs+vLejRLKIuY0Z/xHJJN3Rc46gRxun/w58HitjHuGMYkzqda2GxLeuZca+
HaU8GsNdbWnwLZhAyT8WaRxiZBWCyqaYr8TCEtlpQ5I8jTWCh36N0MGY4xaRDm9OwDwiqmGD
aKqj4L6p1x9fZm1uQRq2aoltFT3WFYvnwHRK7pcytRNZTf8mKn5VlhhtbWT49OwOVJAhQjN7
aIzCNuHLygiZ6uimJm49XfOEgC9zbTU/rWqoONbqg1m9poDuBuFT5BGxJK+xVqtVpT2FwPIl
zRz6Q5A83LDfG7hffzRUqw6Vzvp+jXCpNY7FHuRIocMuHE7ms0eMI4wU7V2nBXToQv7MCeYu
WZC5Vm9rhqpNkXchDRcnZw0kx/S01zEO+u0RFUsjLYVORdoYP/eBb8A0xCDwg8ppd9CqNzS9
o2tHtEGiJ8F0GL76RwVLjSMkSxTsloXbnLaEYxyvRs4SDjtFcJ3AGUIg7lapU22cZbPerrtt
rrdnWtro6O9OvF7FU/ZGELHu4n50dkF/NHfQx9mni874nD7G4dJL6OJvXsTHIW7gSGcyvnHs
kK5Se+7KvoveOkm0nDYsYy5PPalwZccPU8ukfh7mWLnbzJ/hNvaJ3cbSRn9Tt7EPdRvmKodj
TlvQOROudVwBHM78e8yzIhf75yQAPOu9XKJq/rAipipLVbDGyY6g6NcyNsB1DDYmQsE+b32P
DjhhQD9EVR1i7hJfz6r93lm29DfZpqFqmr0MF7au4A6lDZ0YvSPuJhm0C0/ZL21lYnKBSLpD
JCEr3J7Gf8mPceVGEi9Q8uTdO2LUTcbQPdQodjOJgqXAokTETrwMkg2zwTywUXAWXkjZPT9Y
MDZ1NGac6v8AeSYhOtHGppdLYisz3FhFP8aAI+bRRmm7GbqX/QgYTHCLNJQZxlbfxEM/OAJc
CqcDYqnUWXHgrFXFByaY7AiLHI3g/f/tXetzo0iS/3qniP0L7kvN7Ie1IySZAoQeMZ4bW7Z7
vNPu9rbcPT0xseFAgCzaAtSA/OiL+98vswokVOYhzLqP7sXTY0uQv8wiM+uVVVTOTX20tL02
fJjih5gFfcJiwFnMUlgYIyBEFiZjEc8lUXGb/gTLhbG8zLsU7yIzMj5535Mxunh0Bc0qfD04
+XDSeff2ghsfzUyjcvXZk/X7beg1YHyEoTroN2iv9RradhRjs1lQ6OtugL0RMRZ6ELDOsaOp
Wvcn9Wfg1gmMwMaOxrRgsm2wrb7oJoYJfuO7wOcHmC2xUnbgGrbBN2g96DIO2Y6pufmR4LCJ
dSEt5IYpwZnoOZsJmfqSzeGd1YJP89mMC1TAHzHesIx7e2F0C4O+yds3f/BNAxfgIgtUCtNA
pBu8AVVgRP74Y4KLklePS/AjElPl/Ry9gVKxovnrOiRJrYU9xR1Tm11B0O/xDrLLHoiA/7H/
yFEY4mDQJOzyjeVCT26Q4EbisYse69q9EbEHkiqTo/cf2TiAG0yTwFKayq0kb1P+dnySRdly
QD3QaE8OZDwhJ7DieSmuQ0Ta1KEOIVk0tDaSI7zCcE0xRb91eTEiv/s2m4xPdRhp8cYL985h
Hho3LlOyD8Zn4dt1yZTs3YOPUE3tU9VS2+Q+4mXg1/2q7BXOXtrwVSV8Y6IiW5mzleMFwJg5
vyBX5k8j/lORP7ugVeYvZWmdarr2TMWrL2tX9WXsqr6wXdUXtqta1q4TaErZ9vtf2ZT388rC
1ZruT9rPMPoeET5mZBFAaPlXS2TORvsXU4xgzVbQnpir5cJ6YMP1GHAGI8G4z0UglIc1P1cf
Wb8Qf333cYOiZcXQUmK6bfL2t9b5ZWfMNDgir2CQwR4aOr176HXY6y5U6moaTFcoWsN5XC+y
A2+81euqcrenNpXhO60MCfcYew64W2jFLxRx3mx5nO+9OEw4BK6fBLeHcq/Xjf+HiXWb3Nxv
qKistTkvHOwc8g3ZbWJ6jm67h4uVoQcze+F0obNuE9cOOtGdPdfDRScOxXV/tozJxa9d1c+5
jofUHq7X+1Yu25oRLZE60aIqXwblq35ND/599uDrKfN4rrto/GMvavrZZHFE7oBlF/R7ofvG
nMhKHGiZcjoon86G+dD62sgLBpI2jitxWOkvr9k85U5fsKaXXVheh7p/g+8hehhSJEvd1x1c
pguIg7EcmMlFS7Q4s/WQ570Nw9ZIIJ/x4WSQRwlxHw04qW4vYCoc/ACzqzVpN3wIo9cM8Z3B
oLspNH6QRvFUjM0lccF0qi9017A6+gIcVtt/Coj3K12cn5PoZQ02VYqfEnj0JOkp7shkZQ8W
GA/E5qLb1KjvtEaJprdctDrSsF1UgNbd+O2jzSyehVB0aPjvXebRxS5En+FCzYjjmxhx5LoQ
3d2Fmibm+2xiGrt+n3b9SpNrsXlhIyh+YgM8wwyXBq3FI4pe745iDQwft4hoR79dD4HWZGwP
h2vdx60UzFaeIme2jwFesR1bLX9oerbvtGdr7Pp92vUrxesqtFwwXA58nPIZgd2h0XJYvFw6
TqyRJRdIla4sASxrASeCAd/W2Yqt/VxcXvH9cREr6AJAlzRjf0OPvJ6ck9fejW0k9zi0QCPL
ZbTXZC/Yh5bSlFi0sauqF62zE3xLke3teMPoYd45sRwbVGiu2HaHy/Ggr0ha6/TkaEwuxiNc
SR7hulSX8oNtoiP0o/vwXK9sNrzEw1IiX4CZ7O3g2jJ1Ax56vvBcTT2I9iKPyMnph/XSKh10
5ZgTrcZpCJx+1B2zrz34nvMjWX9kL5hcQyeyB8p4H71psNmHtX53J/GS5yx686qTvMR/SCeO
dE1XN//dGp/hC7/46gNxPZKU/0vMJH4UcGj+zhCY+gs8QOvvpyen42ejG8killaSnI9uJItY
uZLkfHQjWcQqlSTnoxvJIlatJDkf3UgWsb1KkvPRjWQRq1WSnI9uJIvYfiXJ+ehGsogdVJKc
j24ki9hhJcn56EayiNUrSc5HN5JF7LSS5Hx0I1nEGpUk56MbySLWrCQ5H91IFrFWJcn56Eay
iJ1VkpyPbiQL2OgwgWdKLkA3kkVspVhvAbqRLGIrxXoL0I1kEVsp1luAbiSL2Eqx3gJ0I1nE
Vor1FqAbySK2Uqy3AN1IFrGVYr0F6EayiK0U6y1AN5JFbKVYbwG6kSxiK8V6C9CNZBFbKdZb
gG4ki9hKsd4CdCNZxFaK9RagG8kitlKstwDdSBaxlWK9BehGsoCNkmI9U3IBupEsYivFegvQ
jWQRWynWW4BuJIvYSrHeAnQjWcRWivUWoBvJIrZSrLcA3UgWsZVivQXoRrKIrRTrLUA3kkVs
pVhvAbqRLGIrxXoL0I1kEVsp1luAbiSL2Eqx3gJ0I1nEVor1FqAbySK2Uqy3AN1IFrGVYr0F
6EayiK0U6y1AN5IFLIM+W3IBupEsYivFegvQjWQRWynWW4BuJIvYSrHeAnQjWcRWivUWoBvJ
IrZSrLcA3UgWsZVivQXoRrKIrRTrLUA3kkVspVhvAfrblMxgIzKZXBF1+PpMktTjViqHWAIl
D+ucochOepAw7fOA5aae6u5tiyePnt3PUdTtwcrFP8SxwrlnttyVM7V8zFPKnpknDRwR2jJm
9rXhmIEVXoM0OZnK2vL1wOoEq2BpuWZn6WM2XYeYK3aMpIHZH6a+d2u5rhUEXRA/NTzfGiUT
5uJhxtGhnnB7FhQRzVfTljfHhLSGyVJT98jR0rcXRJbJ+8kxoV1K/vYWivM38ivmuRtv8iTu
vf11fL4fp0zFxJdRXtP+07ymx3ST17Sfk6CTjiSpK/15sk7QSYfpCTr7/XWxt6AjgqUSy5pF
i4rAp8TckRv9tIkeBPaNa5nsRmRImsWE5a/r99vE9jAnDSY6jzJ5o/LRDJgyMkqDyR3yrxTc
wQssN8rchN/AzVpgDUI70ogiXywYXpihN27fUnjiXbLOBF+gUfp8jdISGqXlNCpnMUnXKE1o
VC6jUTlbo3KRRj1Mr3W8CkOQsXd2tk/+vPz93VmcY3aysKzl9u3J68v17W30+IKjj//Zes8a
jih/jEHmXnhrxUmbI+yrKIWLsVzZrmk98AyIxtK2QVsP8k5USgsfytGXmEIGEyyxJnHBElZi
ahrfCpb8qOI2CW0HrOOtwta7S2igMVMNfGfNjhvqRkgiVmQP3Asa305vv9uy3eUqHJGjK3KF
+TcXLK/mhJ0lDQ809XTfxDQQBywn5wGj5r+lly4ZtsTm9WrJDn63AmyXObANjazv+Yed3tcp
Aua5wKywrIswib9yMQ1RN3kS8+Qyql7Cacystg5SGtNEkuhBfrZjup3tuJde9Qe9lrMM8UDo
EeEp3ZlT2Z4hQYcDH1fLFn4ZkZ4yppICH8b6Up/aC6C1gsP/iUCe/78skyglI8LpX0/OI0ib
nN2/s+4OoRor8lCW5m2oHlDjDmmbXOgP/ziUZZklEj/E4mzSpAKH129fnY9JnCYVmW1ynZ5f
RGlSWeuwSZN6Yvugrs6RYWAKvN3TpMotdiUaRASmPiJ9qmm9odYjPSp3MPE9mZv3PjgNmiMg
e4qmDRVycbzfYuR4grlFLn2PpX3iB4XzO/gAUDtcVLOkgJHYv8FTicwPiIFHeI/YKebQ/899
b3Uzr3npOAH8ovhLBsaEpp9JjknckSaHZJN3lvK8s1Iye+7p0aujq9NN9tzJlaJo/Z7yehzb
l7mFhAeIV3cLZVNBuGO/Ozo/AZlHV+8nZPzr0ZtXp6zp/eAtVo4FtyQRQMgdu4c6d7174i2h
UdGhJlrsnHBolz6voC4Z0PXsJupy/hicoBZTRK3vxcJcGF5azxdBnyGC8PxpdITmJccwFmAt
HzlhqQHJB31hm6zvFihPo8RuT8he2gIvpvcX07agubOjyVWHahL5HfNOMxdWZBiiQu0/CMjJ
FTl/T/5xNCHvrs4JDGJev/0duo23F5dkT+tC1+AG7TiVgqbs85TQnHNO1ZSbqvlNV026c9Wk
TdV8ZtWkL1Y1aV7VVOKqmRhqno2zR5rDpyPNcWLaPswZaSpPRpoZk8yhkjXSpMmRJmpsPKTD
j5kDzfYVU2/79dEbPuaU+ZiTshEjByeGnDKVpadDTriuRGNOKBgrt5SihM1wW5bylSBvKQHG
qWlKkCWapQR5rYT85pSq2kDqn8XtKWtOLyb/ouZ0e8A3HRF5oPXVoToYZI0xsThUiwaZ08xB
5nR7kKlPcYRJUwaZ07xBJrk/IGfvj76VYnK6lXvrYsLDpe6HNgtYhNiw4ehXzh0gT3NINlVd
3a0X/opuY5S1h5FpD2NXexjl3aa2xeR0BW6T0vxHbmPkkGzcplc7tzHL2sPMtIe5qz3M8m5T
22JyugK3kTPdxswh2biNVju3scraw8q0h7WrPazyblPbYnK6ArdRMt0mj2TjNv3auc2srD1m
mfaY7WqPWXm3qW0xOV2B26iZbjPLIdm4zaB2bnNT1h43mfa42dUeN+XdprbF5HQFbtPLdJub
HJKN2wxr5zbzsvaYZ9pjvqs95uXdprbF5HQFbqNlus08hySx1CDVzm/ssgaxMw1i72oQu7zf
1LaYnK7Ab/qZfmPnkCT8Zsc1qq/oN5/KGuRTpkE+7WqQT+X9prbF5HQFfjPI9JtPOSQJv9lx
AeUr+s1tWYPcZhrkdleD3Jb3m9oWk9MV+M0w029uc0gSfqPUzm8WZQ2yyDTIYleDLMr7TW2L
yemKQn7ZoeJFHk3Cc9bBYlxwKLfQUhtfc8oa0ck0orOrEZ3yvlbbYnK6Il/Lji87eTQJX6tf
hNktaxI30yTuriZxy3tObYvJ6Yo8JzvE7ObRJDynfkFmr6xJvEyTeLuaxCvvObUtJqcr8pzs
KLOXR5PwnJQ485NNpJM/LmRNkjpn21uShorcS3jOqWssvGDlW+lek+M5rEysrLmxTRoFNylH
KHwPg/y8PQy4r6A2lWVZ1guXmV643NULl+UrS22LyelyKouSu21gmUOScL/6BUk/lzXI50yD
fN7VIJ/L+01ti8npCvwme1z3OYcksemzfkFSv6xB/EyD+LsaxC/vN7UtJqcr8JvsUZ3fcswR
ccx4Y6HUHUpdhVwcfby+OLk+Of0wOZR7GnRZJ9eT4+uT88lvcKHPQFObvTkDKLZLUe0qwxx5
CSesX8Q1KGvdINO6wa7WDco7YW2LyekKnDB7gBjkkCT8pn4R17CsQcJMg4S7GiQs7ze1LSan
K/Cb7H0IYQ5Jwm/qF3FdlTXIKtMgq10NsirvN7UtJqfL8hvOqwOd09Ly2cQsBAur3X5X6rAv
ZA8mZFoH/snqPrFZxHRhBxbu1HM6Ju78/sW3zLkedg3PiZ0se2PDKock4Yd12Owr6MZZLUJ7
qYfz0bofp12pq5KFp5uWKdjmrqw/3GX6w92u/nBX3m1rW0xOV9DcZW+EuMshSbhZ/UK392UN
cp9pkPtdDXJf3m9qW0xOV+A32Rsh7nNIEn5Ti8Dtq3Py8WxC7u1wTha4gEWm7IgW20V18vMn
gja+lm9a09XN+j2zba0+lLXkQ6YlH3a15EN5h6ttMTldgcNl76B4yCFJOFz99hU/ljXIY6ZB
Hnc1yGN5v6ltMTldgd9k76B4zCFJ+E39NhZ/KWuQL5kG+bKrQb6U95vaFpPTFQU/s6PmX/Jo
Ep5Tv7C5rpe1iZ5zGIi+q1X03ONA0r2n1kWNCItcKDuArut5RImXs+sXQtdLv0OrZ79Eq+/8
Fq3+jLd9a13UiLDIh7KD6fo0jyjhQ/WLgOulX6jVs9+o1Xd+pVZ/xqu/tS5qRFjkQ9mxcN3I
I0r4UEo0/P9nt4RSuFtCUda7JbLiT8THo/06vje13e1YlBTHom4/eSvf1RfAPkS1ujddQsae
49hgTzzS4U5fkB66gOeaQev045XSmQXkXvfxjBQ8T+4BzyYhDkgKicF++xYrcDs+3o1Y8iww
2JEgUK+AN2gWRCMvAtNSKBIej9Xm8qAsJCpTLG3EuYMKZvbCCh6D0HL4ZJZ5y1QH3qYe6kBm
Wt1o7U2CB/JAH2Y3WldzzZ9MpyP/vPWVbn8dbn9Vt79qAlba/i58HWx/7W1/VQReQrn6wm2h
nDSC+7ptQrUCqwceKMwOH5MHm+JZLezEDah6LU7KIQSPTkEV6UaIdY/pkqp4pB+e0AqfooNe
QYi0XpOMQ7pfkDUeK4mVC09S1U1CDyhUyxsraDPeEmLwc6iHK7Cf1DKADC0Y8dpTOfk+K2TU
HICw1sezyYh4waNr2IGJf+KDZMK5BXQzHXy7zU7EAbex8YTKJfgUsu62zjbe8SPw+jF5luxU
9307inKEJFgt8YxCKA97dOshcryFdxMVBgvC3Y4darvhjIWMTv4xFpbukjUhe5QNJXPC77F+
fW8mspfXrB8BPeyN9/HUX6mDSxnkjRUCLcgFg0E7fmXpzgsSn7vgIQumiVt3Bt3VnuEtH337
Zh4yNB0ONeLd2v4vDtR1sxvcT7umtZ/R3q1csa2wHlCf1z4ob49d3hcJaTohFQn7qXT9J/zk
dH6ySJhewCfl66WS9USyQSrZQCSTUsmkJw+RTkefEGqpdJpIpqaSqSLZMJVs+KR06YUTydIN
Ednh36Cr/Eb6vssLPqLmjSE0uvxQZxIsdaCAxjSiXZ9nq8A4Tg/js9CmZO9eDwjV1D5VLbXN
Wm/WCOLX/arsFc5e2vBVJawGFdnKnC3LgSMlmPMLcmX+NOI/FfmzC1pl/lKW1qmma/8SxTd2
/V7sqr6sXdWXsav6wnZVX9iuamPXxq6o+HgYwM4nxVPrMTqDjGFA0sYePZqIcEFd0vrPtzCz
5hkV8Gh7213hbQyhKOtRAp6RClNwLCxZ+jDFgoHEqEU6nQ65N0dA6MNvtcUjUfjc3gh+eyPa
RhYjNkKJ7tK0u3J0U06FRjeVtJvD6KaadjMuUS/tphbd1FJlStHdPrtL8a60vhvfHKRBB9HN
YdrNXqyFVCWtdZSqJBpriaaqqR/fTdUTpf/GRvy27FRiCicQlUd9b2GOgjDBrvPhJpqQFk1o
wgQvESZ4ybiA9DRMgN9vbeMWa5TruZ2ZbwVzNjrgc36ouPrjD7vWm+Kgg1KHoIOgkz99zwt/
uQmdpaQS+P3Pv4ICrODmP/DnwAqNAyxV1zxwTMeDT8CMBbb/8pcU5H/9SaVLx9RNh3ROyAFI
PUCR8QfoYaOfD9HSFBScdvHccOhGyBifAK9e2Y5FcEXRJW+NkJAhjOlG8E9RcXSqcS7vUM2v
2WpHvC7Cbxyh1cgEtEhYXhxFkyWlB8PdYa/fBRu8so/hstzv9il5dbzPQCdcPxGIrYvC/4Ch
itbtRxhV6w7kGMLEc1iAclRcCvRCaMm3Ll761szycXHmwnZBdyPCS3mJCoC22jVQ4GQF4062
RRM7lmV8L2wBLZ6zDi38MTfriJ+7jsF8xuf90gSrxxq7WllMYzC0ofKop47kXkJj7GcSIv0o
ckzsa298tjBIjrirJoqvtH73fFY7ti6SM54AKnERBEyWup9ES62N1Nf6I3o+5kfTfXx3m4/h
D2VOMp6v3NtY+T0q/5aAEvJGZ88mJa+9f39+gtd6hjzTZ+pophszQzeV0VRXlClVcQ+TNFPl
gb5Bnd6BHllpB5z/G56HjZAL/ZPH/jITcdvGHoHqinnwxEtyT4m+0/hDdCeu7WzwQLj/R0PF
CCAwgEnY1p0MBnJrizyBpwKjjALEeEXED8nWnQz8MMarIl4VPqTj1RjfE/Ea2bqTgV/7rybg
qSQwynj+te/0o79r3PpDdMe3HO8OawP/GYgFHggf0gUOYvxQxPfI1p0MfK+19XwJvPjk6fjY
4ajocDR2OJrrcDT2OPrE4/oCp3QG/Rgvelwsd113MgpAW9smS5RgbbIO/8MG5o8YNmB7L2IW
UlrX1vrDW5G5DgIxU6MD7RjmND240/2DYOl5iwO8dIC4VPT/AUObmuHnZwEA
--------------040703060205080909080801--
