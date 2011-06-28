From: Tom De Mulder <tdm27@cam.ac.uk>
Subject: Software RAID and TRIM
Date: Tue, 28 Jun 2011 16:31:35 +0100 (BST)
Message-ID: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="140733193388032-2110314777-1309275095=:257"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--140733193388032-2110314777-1309275095=:257
Content-Type: TEXT/PLAIN; format=flowed; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,


I'm investigating SSD performance on Linux, in particular for RAID=20
devices.

As I understand it=E2=80=94and please correct me if I'm wrong=E2=80=94curre=
ntly software=20
RAID does not pass through TRIM to the underlying devices. TRIM is=20
essential for the continued high performance of SSDs, which otherwise=20
degrade over time.

I don't think there would be any harm in this command being passed through=
=20
to underlying devices if they don't support it (they would just ignore=20
it), and if they do it would make high-performance software RAID of SSDs a=
=20
possibility.


Is this something that's in the works?



Many thanks,

--
Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
+44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
-> 28/06/2011 : The Moon is Waning Crescent (22% of Full)
--140733193388032-2110314777-1309275095=:257--
