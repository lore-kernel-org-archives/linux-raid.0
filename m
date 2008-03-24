From: Nagy Zoltan <kirk@bteam.hu>
Subject: Re: component growing in raid5
Date: Mon, 24 Mar 2008 16:17:29 +0100
Message-ID: <47E7C609.9000501@bteam.hu>
References: <47E5FFB8.5030903@bteam.hu> <47E753C4.7030903@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E753C4.7030903@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi

> I would simply use a v1.1 superblock which will be situated at the 
> start of
> the array. Then you will face another problem - once you grow a leaf 
> device,
> mdadm will not see the new size as it will find the superblock at sect 
> 0 and
> will be done there. You will need to issue mdadm -A ... --update 
> devicesize.
> The rest of the operations are identical.
i feeled that there is another solution that i missed  - thank you, next 
time
i will do it this way -- because the system is already up and running, i 
don't wan't
to recreate the array (about the chunksize: i've got back to 64Kb chunks 
because
of that bug - i was happy to see it running ;)
>
> As a side note I am also curious why do you go the raid55 path (I am 
> not very
> impressed however :)
okay - i've run thru the whole scenario a few times - and always come 
get back
to raid55, what would you do in myplace? :)

i choosed this way because:
    * hardware raid controllers are expensive - because of this i prefer 
rather
        having a cluster of machines (average cost per MB shows that 
this is the
        'cheapest' solution)  this solution's impact on avg cost is 
about 20-25%
        compared to a single stand-alone disk - 40-50% if i count only 
usable
       storage
    * as far as i know other raid configurations take a bigger piece 
from the cake
        - raid10, raid01 both halves the usable space, simply creating a
        - raid0 array at the top level could suffer complete destruction 
if a node
            fails (in some rare cases the power-supply can take 
everything along
            with it)
        - raid05 could be reasonable choice providing n*(m-1) space: but 
in case of
            failure a single disk would trigger a full scale rebuild
    * raid55 - considering an array of n*m disks, gives (n-1)*(m-1) 
usable space
        with the ability to detect failing disks and repair them, while 
the cluster
        is still online - i can even grow it without taking it offline! ;)
       and at the leafs the processing power required for the raid is 
already there...
       why not use it? ;)
    * this is because with iscsi i can detach the node, and when i 
reattach the
       node it's size is redetected
    * after replacing a leaf's failing drive, the node itself could 
rebuild it's local
        array, and prevent the triggering of a whole system-scale rebuild
    * an alternate solution could be: drop the top level raid5 away, and 
replace it
       with unionfs - by creating individual filesystems, there is an 
intresting thing
       about raiding filesystems(raif)
    * the leaf nodes are running with network boot, exporting their 
local array
       run thru a dm_crypt on iscsi - this is something i would do 
differently next
       time.. i don't know how much parralelism dm_crypt could achive,
       but doing it on a per device basis - would provide 'enough' 
parralelism for
       the kernel to better utilize processing power
    * the root's role is to manage the filesystem, monitor the leafs - 
and provide
       network boot for them
    * effectively the root node is nothing more than a HBA ;)
    * the construction of the system is not complete - i'm waiting for 
some gbit
       interfaces, after they arrive the root will have 4Gbit link to 
the leafs, and
       by customizing the routing table a bit, it will see only a 
portion of the leaf
       thru each of them - i can possibly trunk the interfaces, but i 
think it's not
       neccessary
    * this cluster could scale up at any time by assimilating new nodes ;)

kirk

