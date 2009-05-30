From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 reconstruction ?
Date: Sat, 30 May 2009 16:46:13 +0100
Message-ID: <4A2154C5.6050500@anonymous.org.uk>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com> <4A213612.7080206@anonymous.org.uk> <4A213D6B.8040501@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A213D6B.8040501@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/05/2009 15:06, Maxime Boissonneault wrote:
> I don't know how it goes for Linux, but hasn't ZFS been developped 
> exactly for that purpose ? From what I understand, ZFS manage both the 
> file system and the RAID features at once. Therefore, the "raid" part 
> knows where are the files and the filesystem knows about the raid. 
> Reconstruction is then done intelligently (not reconstructing unused 
> space).

Yes, ZFS can do this, but ext4 and md could do it too, and probably will 
at some point. I prefer separating the layers, then I can switch one and 
not the other, e.g. start using a hardware RAID controller instead of md.

Cheers,

John.
