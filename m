From: Roberto Spadim <roberto@spadim.com.br>
Subject: raid1 new read_balance
Date: Sun, 6 Feb 2011 01:59:25 -0200
Message-ID: <AANLkTi=FEjqjzzn+soCbPdX=Q1Qt2JKxQ0y3PPTJsLE3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi neil i think i ended the first version of read_balance options
could you check?
i need more help with sysfs (i put the time based configuration in
only one file, sysfs filosophy shows that's wrong, but i don't know
how to make it per mirror... :/)
another thing, can i get a per mirror i/o list? for example
mirror 1, what's the current i/o queue?
how many writes in queue?
how many read?
what's the min() and max() sector of queue?

the source is kernel 2.6.37 based, can be found here:
http://www.spadim.com.br/raid1/

using: /sys/block/md0/md/read_balance_mode
you can select read mode
    near_head = current raid1 read_balance
    round_robin = a patch of Roy Keene (linux-raid at rkeene.org)
    stripe = make a division (stripe) of read
    time_based = select the best disk based on distance (current head
position sector - read sector)*head_distance_rate + read_sectors *
read_sectors_rate  + queue_io_time (this i need to implement)

for stripe there's a file to configure it
/sys/block/md0/md/read_balance_stripe_shift
the selected disk for stripe is:
((current_sector >> stripe_shift) & 0xeff) % raid_disks
for time based there's another file configuration:
/sys/block/md0/md/read_balance_time_config
if you use cat you get all information about mirror
you should use:
echo "x y z w" > read_Balance_time_config
x = raid mirror id (index of conf->mirrors[])
y = head_distance_rate
z = read_sectors_rate
w = write_sectors_rate

how to use yzw:
if you use two disks:
first: 10ms of access time
second: 2ms of acess time
for disk1: y =1
for disk2: y =5

first: 10mb/s read rate (test with dd of=/dev/zero if=/dev/sda)
second: 20mb/s read rate
for disk1: z = 2
for disk2: z = 1

first: 20mb/s write rate (test with dd if=/dev/zero of=/dev/sda)
second: 10mb/s write rate
for disk1: w = 1
for disk2: w = 2


that's it :)
the timebased run only once (at begin of read_balance)
if error (goto retry) it will use near_head, but not change the
read_balance_mode variable


it's time to test, and benchmark
i need a help with bio queue if you could help me :)
thanks =)



-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
