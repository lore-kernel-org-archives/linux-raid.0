From: Steven Dake <sdake@mvista.com>
Subject: Re: Help!About MD on shared storage.
Date: 04 Aug 2003 10:40:28 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1060018828.5102.78.camel@persist.az.mvista.com>
References: <OF24C833E9.81D2D2DC-ON48256D78.001F7244@legend.com.cn>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OF24C833E9.81D2D2DC-ON48256D78.001F7244@legend.com.cn>
To: hufh@Lenovo.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hufh,

Unfortunately I don't have the patch anymore, but it should be in the
archives (search for multihost RAID).

Basically it locks a RAID volume on shared storage to a specific node in
the cluster.  This allows you to use RAID autostart on each node and
during startup, the superblock will be checked to determine if the RAID
volume specified in the superblock has the same SCSI host ID as the
current host.  Then you can specify different host adaptors for each
host, which locks the RAID superblock to a specific host.

This does not allow using multiple hosts to the SAME RAID volume, and
only provides exclusive access.

Note that the same thing can be done using a configuration file per node
and using mdadm to only start the RAID volumes needed.  This is the
methodology recommended by RAID maintainer, Neil Brown, however, I find
it difficult to setup which is why I proposed the patch.  He could
probably provide more info on that methodology or there is a discussion
in the archives.

If I ever get some time, I plan to implement shared access to the same
RAID volume for usage in a clustered filesystem application such as GFS.

On Tue, 2004-08-03 at 22:48, hufh@Lenovo.com wrote:
> Mr Dake:
> I am very sorry to bother you. I encountered some troubles.
> MD device is used in my 3 node cluster, and each node need
> access. I know you contribute a patch, but i cannot find it
> in LKML, could you mail me and tell me it's main idea?
> Thank you very much.
> Best Regards!
> 
> Yours Sincerely
> Hu Fenghua
> 
> 

