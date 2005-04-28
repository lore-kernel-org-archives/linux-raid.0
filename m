From: "miele\@inwind\.it" <miele@inwind.it>
Subject: Re: Can you help me on Linux SW RAID?
Date: Thu, 28 Apr 2005 13:41:45 +0200
Message-ID: <IFNN5L$54F0619DC10E22BF63406272D5963076@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jakob <jakob@unthought.net>
Cc: linux-raid <linux-raid@vger.kernel.org>, mingo <mingo@chiara.csoma.elte.hu>, bueso <bueso@vives.org>
List-Id: linux-raid.ids

Thanks for your reply Jakob!!

Obviously I've plan to use OCFS (Oracle Cluster File System) to share data access between nodes...
..I've to implement an Oracle 9i RAC.

Anyway i've made a test.
I've mount a normal fs on my LV, created a text file with "vi" and saved it on both node with different value. It seems function. To work-around data buffering, after unmount and remount the fs, my file contains the values modified my the last node.

Data buffering problem should be solved by OCFS..

You discourage anyway my use of RAID??

Thanks.
Andrea

> On Thu, Apr 28, 2005 at 12:11:37PM +0200, miele@inwind.it wrote:
> > 
> > Hi.
> > 

> ...
> > All is wonderful but.. when all seems ok and my work seems to be finished..
> > ..I'm having hard doubts on this RAID configuration and its stability.
> 
> With good reason - there is no way that this can work reliably.
> 
> > I fear that RAID SW modules that runs on each of two Linux nodes, and
> > works on the same data of the shared disk array, could produce
> > conflicts, misalignments, or I don't know what other..
> 
> This is exactly what will happen. It will not work.
> 
> > 

> > Can you give me a comment or suggests about RAID SW use i've made?

> > 
> 
> You cannot share storage between multiple SW RAID "masters".

> 
> If you take SW RAID and LVM out of the equation, you will still have
> problems with the filesystem - you cannot share storage between two

> nodes by mounting the same storage.  Again, both nodes will write to the
> journal with no synchronization between them, both will cache data

> locally with no cache synchronization, etc. etc.  Disaster lies ahead.

> 
> Look into GFS for a solution to the filesystem problem.
> 
> You can use some of the linux-ha stuff to make sure that only one node
> at a time will actually use the underlying storage, if that is an
> acceptable solution (pure fail-over).
> 
> But all in all, there's no plug'n'play solution for what you're trying
> to accomplish.
> 
> Personally, I think I'd get a "storage box" which did the RAID for me
> (that could be an off the shelf iSCSI/FC box, or it could be another
> Linux box exporting a software RAID over iSCSI, it could be a lot of
> things depending on your needs and budget), then, I'd look into GFS or
> Oracle's recently opensourced shared filesystem for the shared
> filesystem.
> 
> Maybe others on this list have better suggestions.
> 
> But first of all; stop what you are doing now, you are hurting yourself
> and your data  ;)
> 
> -- 
> 
>  / jakob
> 
> 



____________________________________________________________
6X velocizzare la tua navigazione a 56k? 6X Web Accelerator di Libero!
Scaricalo su INTERNET GRATIS 6X http://www.libero.it


