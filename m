From: Michael Evans <mjevans1983@gmail.com>
Subject: mdadm reshape stop, resume with alternate/moved backup file?
Date: Mon, 2 Nov 2009 16:44:41 -0800
Message-ID: <4877c76c0911021644r3e983f5bh5fa8d7b14a37b2ab@mail.gmail.com>
References: <4877c76c0911021643x6f1a0e37h795963451e521d0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911021643x6f1a0e37h795963451e521d0c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the past I'd only worked with software raid5, it used the temporary
file for a brief period at the beginning and then it was all
disk-bound.

I recently started a raid-6 takeover of one of my larger raid-5
arrays, it is running around 1/10th to 1/20th the speed I expect:

=A0=A0=A0=A0=A0 2909829120 blocks super 1.1 level 6, 128k chunk, algori=
thm 18
[8/7] [UUUUUUUU]
=A0=A0=A0=A0=A0 [=3D>...................]=A0 reshape =3D=A0 7.2% (35359=
488/484971520)
finish=3D11057.6min speed=3D677K/sec

I suspect this is because another array sharing the same devices is
where I put the temporary file, and further that it might be waiting
for complete hardware syncs before proceeding.=A0 If that's the case I
expect that using a small, currently unused, area on unrelated block
devices would speed the operation up by at least 5x.

Can I safely pause the current restripe process ( 1060 pts/... =A0=A0 S=
L
 21:28 mdadm -G /dev/md52 -l6 --backup-file=3D/md52 ) with something
like kill 1060 and then re-invoke it with the backup file in another
location?=A0 Or would it be this increadiably slow anyway?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
