From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm reshape stop, resume with alternate/moved backup file?
Date: Tue, 3 Nov 2009 11:59:18 +1100
Message-ID: <c7b2da7b9a40e206ea3324169cc00d9e.squirrel@neil.brown.name>
References: <4877c76c0911021643x6f1a0e37h795963451e521d0c@mail.gmail.com>
    <4877c76c0911021644r3e983f5bh5fa8d7b14a37b2ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911021644r3e983f5bh5fa8d7b14a37b2ab@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, November 3, 2009 11:44 am, Michael Evans wrote:
> In the past I'd only worked with software raid5, it used the temporar=
y
> file for a brief period at the beginning and then it was all
> disk-bound.
>
> I recently started a raid-6 takeover of one of my larger raid-5
> arrays, it is running around 1/10th to 1/20th the speed I expect:
>
> =A0=A0=A0=A0=A0 2909829120 blocks super 1.1 level 6, 128k chunk, algo=
rithm 18
> [8/7] [UUUUUUUU]
> =A0=A0=A0=A0=A0 [=3D>...................]=A0 reshape =3D=A0 7.2% (353=
59488/484971520)
> finish=3D11057.6min speed=3D677K/sec
>
> I suspect this is because another array sharing the same devices is
> where I put the temporary file, and further that it might be waiting
> for complete hardware syncs before proceeding.=A0 If that's the case =
I
> expect that using a small, currently unused, area on unrelated block
> devices would speed the operation up by at least 5x.
>
> Can I safely pause the current restripe process ( 1060 pts/... =A0=A0=
 SL
>  21:28 mdadm -G /dev/md52 -l6 --backup-file=3D/md52 ) with something
> like kill 1060 and then re-invoke it with the backup file in another
> location?=A0 Or would it be this increadiably slow anyway?

1/ It is safe to stop the array, move the backup file, then reassemble
  the array giving it the moved backup file.
2/ This will actually be significantly faster even if the backup file i=
s
  on the same device as there is a bug which causes the size of the
  data being backuped to be very small (and so very slow) when the resh=
ape
  is first started.  When the reshape is restarted this bug does not ap=
ply
  and you get the backup performed in larger chunks.
3/ There is another bug where by if one of the devices in the array die=
s
  during the reshape, the backup process stops working correctly with t=
he
  result that the reshape goes much faster but the backup is completely
  useless.  If you crash during the reshape after a failed device,
  you will probably lose data.  If you try to stop and restart the
  array after one device has failed, the restart will fail.  However
  this is still the safest thing to do.  I will try to put out some
  updates to mdadm so that you can reassemble the array safely in this
  case (and of course, fix the problem so that the backup is maintained
  throughout the entire run).

So yes, go ahead and move the file.  But if you get a device failure
stop the reshape and ask me to help - I'll get something to you within
24 hours - probably less but I have to allow for time zones...

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
