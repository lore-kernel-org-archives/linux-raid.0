From: Brad Campbell <brad@wasp.net.au>
Subject: Raidreconf ideas
Date: Sun, 25 Apr 2004 11:12:58 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <408B64FA.7070205@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

Slowly making progress on feature bloating raidreconf :p)

Currently, raidreconf chews through the disks, marks them dirty and then starts the array, letting 
the kernel calculate the parity and perform a raid rebuild.
One idea that hpa planted in my head was calculating parity blocks on the fly and writing them out 
as the reconfiguration is taking place, leaving the array clean at the end of the reconfig.
Does anyone think this might be a feature they would find handy? It's an interesting exercise and 
one that I guess could possibly (if implemented right) help minimise data loss from a disk failure 
during a reconf. (With the journaling I'm adding to raidreconf it keeps detailed journals on exactly 
where the reconf progress and I guess if a drive failed you could swap it out and let raidreconf 
rebuild all available data on that drive before reconfiguration continues). I guess you might lose 
one or two stripes depending on where reconf was up to when the disk went boom and how many parity 
blocks had had a chance to be written. It's pretty academic as it could still explode the filesystem 
on the array, but I thought it was an interesting idea none the less.

For my journaling testing I had the idea to hook up my spare PC to a mains relay connected to a 
random timer, to subject the process to random power failures while it continuously reconfigured 
arrays in my test rig. (I have a setup currently where I have about 5 arrays configs respectively 
for RAID0,5,6 and randomly convert to and from all these formats sequentially with data verification 
after each conversion to ensure it's all happy)
This would be pretty hard on the hardware and I'm wondering if there is a better way to simulate 
hard errors (Like power failure and disk failure) while still replicating stuff like data being 
written and not making it to the disk.

The other sticking point is how to make sure a disk write is not re-ordered.
I have 2 journal structures and I alternate between these using an iteration counter..
Something like this
Write journal to J1
fsync
Write usage counter to J1
fsync
++usage-counter
Do stuff
Write journal to J2
fsync
Write usage counter to J2
fsync
++usage-counter
Lather-rinse-repeat.

Will this process *Guarantee* that the usage counter gets written after the last of the journal 
data? or is it even remotely possible that the journal could not be completely flushed prior to the 
usage counter being updated.

Regards,
Brad

(This is far more interesting than I have even considered possible, it's great fun!)
