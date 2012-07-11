From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Does mdadm supports TRIM command to SSDs?
Date: Wed, 11 Jul 2012 18:44:08 +0200
Message-ID: <4FFDAD58.8090101@fastmail.fm>
References: <CAF-9JegPGmayAO0gAsqY4J3rpRpTq_ciLA5e+nu0PsSjJhwr-A@mail.gmail.com> <4FFD632F.3060407@hesbynett.no> <4FFDA815.4080006@fastmail.fm> <CAF-9JeiKvs+_aXF0gCJxLkGJsVqnqhBvcW7q2UyyDLSFoysxLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-9JeiKvs+_aXF0gCJxLkGJsVqnqhBvcW7q2UyyDLSFoysxLQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bar Ziony <bartzy@gmail.com>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2012 06:22 PM, Bar Ziony wrote:
> If they are connected to a regular LSI controller they won't get TRIM
> commands... How do you know they need TRIM?
> 

We discussed this with LSI, their answer from generic support was
basically nonsense, IMHO. This is a SAS Raid Controller, but after we
run into the trim issue for the first time, we are using it in non-raid
mode (flashed the corresponding fw). After we did so, we can trim with
sg_unmap, but as we don't know which blocks are in use by the
filesystem, we obviously have to trim the entire disk. And that means we
have to recreate LVM + file-system every time trimming is required.
Basic problem of those LSI controllers is that they don't announce their
trimming capabilities via scsi VPD or Read Capacity (16), which the
linux-scsi layer uses to query the disk for trim support. So the actual
problem is the LSI SATA-to-SAS translation, which doesn't seem to let
those important information through.
I already thought about writing a kernel patch to set those values vai
sysfs, but it probably will not get accepted, as setting the wrong
values would result in data corruption after trimming...

We are an HPC development group and our cluster is used sometimes for
benchmarking. Once trimming is required, write performance of those
disks goes down by about 50%. After manual sg_unmap performance is fine
again...

Cheers,
Bernd
