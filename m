From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Really messed up raid0 array
Date: Mon, 5 Jul 2004 14:06:48 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407051806.i65I6m329971@watkins-home.com>
References: <40E93DFC.6070507@pulz.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E93DFC.6070507@pulz.no>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have some ideas...oops you said the f word, bye.

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Geir R=E5ness
Sent: Monday, July 05, 2004 7:40 AM
To: linux-raid@vger.kernel.org
Subject: Really messed up raid0 array

Hi

When i woke up this morning i noticed my ps aux shuddenly stop during=20
listning proccess, and refuses to abort or complete it self.
So i started to worry that something is wrong, i noticed in dmesg that=20
one of my sw raid arrays had got errors during the night.

hdn: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
hdn: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D51001032,=
=20
high=3D3, low=3D669384, sector=3D51001032
end_request: I/O error, dev 58:40 (hdn), sector 51001032

So i try to unmount the device with the unmount -f /some/messedArray,=20
but it refuses to let me unmount it.

So is there anyway to force shutdown the raid array ?
since raidstop doesn't let me shutdown since the array is "active".

Best Regards
Geir R=E5ness
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
