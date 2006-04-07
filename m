From: andy liebman <andyliebman@aol.com>
Subject: Real Time Mirroring of a NAS
Date: Fri, 07 Apr 2006 06:47:18 -0400
Message-ID: <44364336.7060704@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm looking for a way to create a real-time mirror of a NAS. In other 
words, say I have a 5.5 TB NAS (3ware 16-drive array, RAID-5, 500 GB 
drives). I want to mirror it in real time to a completely separate 5.5 
TB NAS. RSYNCing in the background is not an option. The two NAS boxes 
need to hold identical data at all times. It is NOT necessary that the 
data be accessed from both NAS boxes simultaneously. One is simply a 
backup of the other.

I guess one option might be to use Redhat's Global File System (GFS). 
Although there seems to be an 8TB limit for a GFS filesystem, which 
could be an issue down the road.

But would the following approach work:

Can I export NAS B as a SAN or ISCSI target, connect the two machines 
with, say, mryinet cards or 10 GbE TOE cards, mount the NAS B volume on 
NAS A, and create a RAID-1 mirror of the two volumes? Is this kind of 
thing done?

Andy Liebman


