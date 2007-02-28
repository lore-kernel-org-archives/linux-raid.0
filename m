From: "Rich Deeming" <rdeeming@bladeracing.com>
Subject: RAID5 4 disk recovery advice
Date: Wed, 28 Feb 2007 15:38:46 -0700 (MST)
Message-ID: <19306.208.47.132.224.1172702326.squirrel@ssl.bladeracing.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20070228153846_52452"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_20070228153846_52452
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Greetings,

Before taking chances on recovery I would like to gain better knowledge
about what I Googled around for.

I have 4 SATA drives split between two different controllers with two
RAID5 partitions defined.  My system froze and so a hard reset was done. 
Both RAID5 groups md1 and md2 failed to assemble upon reboot.  md0 is
RAID1 /boot.  md1 is mounted as / and md2 is just data for what its worth.

Loading FC6 linux rescue what I see comparing md1 to md2 RAID5 groups is
very similar.

md1 - /dev/sda2 /dev/sdb2 indicate that of the four drives 0 is "removed"
and 1 is "faulty removed".  2 and 3 are "active sync".
      /dev/sdc2 /dev/sdd2 indicate all four drives are "active sync".

md2 - /dev/sda5 /dev/sdb5 indicate that of the four drives 0 is "removed"
and 1 is "faulty removed".  2 and 3 are "active sync".
      /dev/sdc5 /dev/sdd5 indicate all four drives are "active sync".

From what I have read this is my best hope in recovering the raid groups.
mdadm -As --force --run /dev/md1 /dev/sd?2
mdadm -As --force --run /dev/md2 /dev/sd?5

Would this be about the safest thing to do to try and recover?

Any thoughts on this approach?
http://www.chiark.greenend.org.uk/~peterb/linux/raidextract/

Thanks for your time,
Rich
------=_20070228153846_52452
Content-Type: application/gzip; name="mdadm.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="mdadm.tar.gz"

H4sIABcJ5UUAA+2ZXXObOBSGc+1focvsRam+Bdy1SdvZ2Wan0zS71wLkhsY2HcCe9f76FcIiTurY
tbPFeHKeG7Ckoy/L73nBVaZpUP9Tn/1CsEVy7q6Wx1eiMDsjWChCMafKtiOECHKG8K+clGde1bpE
6Kwsiq2bsKv+RHmdmcXryh6CeIQ6rvTXPEUx0hFNuBmnXdVfpqzyYmarMA4iHGC8FoVubn6/dFU0
IZHBsZRG4yg0McVSUc2zWI1FxjRJbNRFaXTd9PUlnxobda1rdGlSRCQiYSxkzBii9ty0A3zWeYY+
moWZ2Kal/SBc+aVZ5KlB1/m/TRdEMKEiQdE54YEU6EP+1pYFiqEPb39r+3lTlnrp23OJFQuFROec
BRF37bkKSOjbu1HbMaqmvS37UtR68qDsU2nGpixNhq7yWVE28xi5wW6+Z7o2fn1XdqnvTYKoRJjE
GMf2xq5PrW3gdd20j1E6MXo2Qm/SOl+YtbHo6O+ivMtnXx+Uofc6n5j1eRLb5/V3Xa7Hdl/Uxa1J
76r51JaxVESaK4peobSwK0jr+8m8W5hZ7QIDSsPRfcVHvSzmta2YmHH9qlpOp6Yu89URubidz+78
9lIh//CBf86niSnd0fpWuKvbq3aL/bfYLH9U3+aVC2GrAUM/MvU3qxrd7k+1nKX2U3eQ3ZDYtcCr
AH/94aY002JhsiaCuALyZMSqZqznk3q5HkgfTM7Pljye9sbZJnTUrefg9T7r9297EEfXf0I6/Wec
Ov3nCvS/D/wxEv+f/jOZZCFLdcylwBFJSZxFJCNa0jg0OmQ84rv1X8VY7av/VqhIqAizgk6JCiR1
ik4ZC6R8IgXIkAtJOA7RuRQ0CNukoZrVRc/MAvREsgC19gsLwndkARINIwuIn1JFMYwsQH1P27OA
2JIFfna9B/7+mxx0dP1f8//M3jv9Z6D/fdAZEfD/L9T/h3iY/v9gRz0I5T8d/58My/+L1fsf0P9e
6CwI+P8X7f/prrdAR/L/BzvqQWSBU/D/6fH9P+P3+k9w6/8l6H8frA5QCv6/R/+Pm/xG6L7Kzzco
P9+g/Hgf/890uNP/02Mov9dcr4SM+yngLUqYbvL/e3eBHmcC34N4nAk29pDRk3kwsMs9vv/na+9/
JGn9P7z/7wV/5sH/9+7/2yzAnsoC7a+6hzTgHgBYGO18ACCDSAPKT2Grhm96ANi7C/RkGvCavD0N
iOE/GTTJ6uj6/8D/w/ufPukcC/j/F+r/Ez1M/3+w9Qb/v5f/zwbm/4XTf8lB//ugsyrg/1+2/4+S
Yfr/g603+P/n/TMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMCp8B/riENZAFAAAA==
------=_20070228153846_52452--


