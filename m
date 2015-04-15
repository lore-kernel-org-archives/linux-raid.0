From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm raid 5 one disk overwritten file system failed
Date: Wed, 15 Apr 2015 19:27:13 +0100
Message-ID: <552EAD81.6090202@youngman.org.uk>
References: <020601d04c17$08c10290$1a4307b0$@johnandre.net> <alpine.DEB.2.02.1502191218140.4007@uplift.swm.pp.se> <021f01d04c4c$5def1740$19cd45c0$@johnandre.net> <alpine.DEB.2.02.1502191521450.4007@uplift.swm.pp.se> <00b901d07771$f56c0010$e0440030$@johnandre.net> <alpine.DEB.2.02.1504151432250.16871@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1504151432250.16871@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, John Andre Taule <post@johnandre.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/04/15 13:38, Mikael Abrahamsson wrote:
> On Wed, 15 Apr 2015, John Andre Taule wrote:
> 
>> The guy that did this to us got 3 months jail.
>>
>> His argument was that we should have failed the system manually
>> (removed the
>> disk that he targeted with "dd"), and the raid should have magically
>> fixed
>> itself. Anyone think this would have worked?
>> It was 5 hours of heavy write and deletes to the file system (ext4)
>> and all
>> that time the dd command where running.
> 
> Not a chance, after 5 hours dd basically had overwritten 1/3 of the data
> spread out across a large portion of the volume. We're talking massive
> file and filesystem corruption.

Wouldn't failing the drive and then adding it "as new" (triggering a
rebuild) recover any files that hadn't been modified while the dd was
running?

Of course, that still means any directories that had been modified would
likely have also been corrupted, in all probability landing the files in
them into "lost+found" and necessitating a massive recataloging of all
the files in there.

The data would have been recovered, but the directory structure ... not
a nice recovery job.

Cheers,
Wol
