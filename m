From: Rich Rauenzahn <rrauenza@gmail.com>
Subject: reshape from raid5 to raid6 failed -- and backup file is gone?
Date: Thu, 22 Apr 2010 11:32:59 -0700
Message-ID: <n2j657cbef51004221132uf2d7f5cds1268f848fee1489e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The system froze sometime in the middle of the night, and oddly... the
--backup-file I specified last night is missing.  Is there any reason
that mdadm would unlink it for a short span of time during the
reshape?

The raid5 array was 4x500GB drives, I was reshaping to raid6 by adding
another 500gb drive.

$ sudo mdadm --assemble /dev/md1
mdadm: Failed to restore critical section for reshape, sorry.
      Possibly you needed to specify the --backup-file

FC12, using

$ mdadm --version
mdadm - v3.1.1 - 19th November 2009

sudo mdadm --assemble /dev/md1 --backup-file=/.MEDIA/tmp/mdadm.backup
mdadm: backup file /.MEDIA/tmp/mdadm.backup inaccessible: No such file
or directory
mdadm: Failed to restore critical section for reshape, sorry.

[rrauenza@tendo ~]$

Hmmm...

I wonder if I hit this - as I might have had a drive failure based on
some extra noise at bootup:

3/ There is another bug where by if one of the devices in the array dies
  during the reshape, the backup process stops working correctly with the
  result that the reshape goes much faster but the backup is completely
  useless.  If you crash during the reshape after a failed device,
  you will probably lose data.  If you try to stop and restart the
  array after one device has failed, the restart will fail.  However
  this is still the safest thing to do.  I will try to put out some
  updates to mdadm so that you can reassemble the array safely in this
  case (and of course, fix the problem so that the backup is maintained
  throughout the entire run).

I'm currently running a smartctl -t long against all of the drives...

Any other ideas in the meantime?   I suspect I've lost my 1.5 TB array :(

Rich
