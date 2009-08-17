From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: max number of devices in raid6 array
Date: Mon, 17 Aug 2009 17:06:55 +0100
Message-ID: <4A89801F.5050907@anonymous.org.uk>
References: <20090812090600.GF21118@nfs-rbx.ovh.net>	<55226.78.86.108.203.1250069920.squirrel@www.yuiop.co.uk>	<20090812121911.GG21118@nfs-rbx.ovh.net>	<87ab259j8m.fsf@frosties.localdomain>	<60099.78.86.108.203.1250094780.squirrel@www.yuiop.co.uk> <87zla44e9a.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zla44e9a.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: David Cure <lnk@cure.nom.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/08/2009 03:52, Goswin von Brederlow wrote:
[...]
> I would take that with a verry large pinch of salt. From the little
> experience I have that value doesn't reflects reality.

You're probably right, given that the data error rate hasn't dropped (it 
might have grown, given the higher areal densities, but in fact it's 
been about 1 in 10^15 for a while) while drive size has grown.

While I was looking at the IDEMA LBA standard stuff, I found their paper 
about long sectors (also discussed here recently) which features a wee 
graph of hard drive capacity vs rebuilds before data loss in a 7-drive 
RAID-5 with 512-byte sectors, showing about 450 rebuilds for 36G drives 
but only 10 for 1.5T drives. See page 9: 
http://www.idema.org/_smartsite/modules/local/data_file/show_file.php?cmd=download&data_file_id=1779

Cheers,

John.
