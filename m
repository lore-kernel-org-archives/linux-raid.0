From: =?ISO-8859-1?Q?Geir_R=E5ness?= <post@pulz.no>
Subject: Really fucked up raid0 array
Date: Mon, 05 Jul 2004 13:39:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E93DFC.6070507@pulz.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

So i try to unmount the device with the unmount -f /some/fuckedArray,=20
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
