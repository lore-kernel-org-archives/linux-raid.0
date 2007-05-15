From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: removed disk && md-device
Date: Tue, 15 May 2007 11:52:09 +0200
Message-ID: <878xbqpg6u.fsf@informatik.uni-tuebingen.de>
References: <200705091417.09033.bs@q-leap.de>
	<17987.51381.756955.577977@notabene.brown>
	<46442E9C.3050603@msgid.tls.msk.ru> <200705111122.17389.bs@q-leap.de>
	<4644D487.9030003@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4644D487.9030003@tmr.com> (Bill Davidsen's message of "Fri, 11
	May 2007 16:39:35 -0400")
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-hotplug-devel@lists.sourceforge.net, Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Neil Brown <neilb@suse.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, 416512@bugs.debian.org, David Greaves <david@dgreaves.com>
List-Id: linux-raid.ids

Bill Davidsen <davidsen@tmr.com> writes:

> Bernd Schubert wrote:
>> Yep, thats exactly what I'm talking about and its not only limited
>> to usb, but happens with sata as well.
>>
>
> And real SCSI hot plug drives if you pull the wrong one.

The right thing to do would be to change the raid superblock before
the first write. That would allow pulling disks out and re adding them
as long as no change is written to the raid. Coupling the change in
meta data with the actual change in real data is clearly the best
approach. No false positives or negatives.

MfG
        Goswin

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
