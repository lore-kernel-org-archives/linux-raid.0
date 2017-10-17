From: Liwei <xieliwei@gmail.com>
Subject: RAID6: Reducing to Grow
Date: Tue, 17 Oct 2017 13:09:45 +0800
Message-ID: <CAPE0SYzB49Vk-QcKWGzVDCqwYjnatGYWrFVeb+jdMF-5wry9Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,
    tldr: Have a mixed-sized (2TB and 6TB) RAID6 array, realised there
is now more potential space (using only 6TB drives) than running the
array based on the 2TB "smallest-drive" size. Is there a way to
convert to using only the 6TB drives, without a rebuild?


   Got an odd situation here. We have a 10-drive array that started
out with 2TB drives. A few years back we started planning for an
upgrade but didn't find justification for acquiring 10 new drives. So
we decided to "gradually migrate" by expanding/replacing storage with
a new 6 TB drive twice a year, and replacing failed 2TB drives with
6TB ones, the hope is that we would have replaced all 10x 2TB drives
by the time storage growth requires it.

    Today we have a 13-drive array with 7x 2TB drives and 6x 6TB
drives. It just occurred to me that we actually have more potential
storage than what the array currently provides. So my question is, is
there a way to reduce the number of drives to just the 6x 6TB drives
and fully utilise all the storage, all in one step, without requiring
a backup and restore? We're using a cloud backup service, so it will
take months for a restore operation (or pay a few K for them to mail
us the data in physical drives, which will be more expensive than just
outright replacing the remaining 7 drives with 6TB ones)

Thanks!
Liwei<div id="DAB4FAD8-2DD7-40BB-A1B8-4E2AA1F9FDF2"><br />
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
