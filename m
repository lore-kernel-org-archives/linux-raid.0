From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Is there a good reason why I can't "mdadm -Gfn1 /dev/md1" ?
Date: Thu, 9 Jun 2005 21:12:02 +1000
Message-ID: <17064.9218.919914.356958@cse.unsw.edu.au>
References: <E1DgFzi-0007K9-00@mta2.cl.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Piete Brooks on Thursday June 9
Sender: linux-raid-owner@vger.kernel.org
To: Piete Brooks <Piete.Brooks@cl.cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 9, Piete.Brooks@cl.cam.ac.uk wrote:
> I really love having my partitions as RAID1 devices as it allows the actual 
> partition major and minor numbers to change, and allows me to "move" 
> partitions by adding and removing them from the array.
> 
> As such I do this even when there is only one partition. To move it, I can 
> make it a two way mirror, add the new partition, then remove the old. However, 
> I can't then shrink it back to being a one way mirror. Is there a good reason 
> for this, or is it just not something that was considered sane?
> [ "really" just runs a command as root ]
> 
> bedat-32:~: really mdadm -Gn1 /dev/md1
> mdadm: '1' is an unusual number of drives for an array, so it is probably
>      a mistake.  If you really mean it you will need to specify --force before
>      setting the number of drives.
> bedat-32:~: really mdadm -G --force -n1 /dev/md1
> mdadm: option f not valid in grow mode

Hmmm.... yes... Didn't think of that did I?

I'm very close to releasing mdadm 1.12.0.  It will have this fixed.

If you are impatient, the patch against 1.11.0 is very simple.  See
below.

Thanks,
NeilBrown


### Diffstat output
 ./mdadm.c |    1 +
 1 files changed, 1 insertion(+)

diff ./mdadm.c~current~ ./mdadm.c
--- ./mdadm.c~current~	2005-06-08 14:41:33.000000000 +1000
+++ ./mdadm.c	2005-06-09 21:08:40.000000000 +1000
@@ -466,6 +466,7 @@ int main(int argc, char *argv[])
 			continue;
 
 		case O(BUILD,'f'): /* force honouring '-n 1' */
+		case O(GROW,'f'): /* ditto */
 		case O(CREATE,'f'): /* force honouring of device list */
 		case O(ASSEMBLE,'f'): /* force assembly */
 		case O(MISC,'f'): /* force zero */



> bedat-32:~: really mdadm --force -Gn1 /dev/md1
> mdadm: -G would set mode to grow, but it is already manage.
> bedat-32:~:  mdadm -V
> mdadm - v1.6.0 - 4 June 2004
> bedat-32:~: rpm -q mdadm       
> mdadm-1.6.0-2
> bedat-32:~: 
> 
> Any ideas?
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
