From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: question about the best suited RAID level/layout
Date: Sun, 07 Jul 2013 14:46:21 +0200
Message-ID: <51D9631D.403@fastmail.fm>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>  <51D6CBF9.2020100@turmel.org>  <1373073066.10569.30.camel@fermat.scientia.net>  <51D77ECF.5090909@turmel.org> <1373133349.8557.5.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373133349.8557.5.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/06/2013 07:55 PM, Christoph Anton Mitterer wrote:
> On Fri, 2013-07-05 at 22:19 -0400, Phil Turmel wrote:
>> I think you should read Neil's blog entry
> I did ;)
> 
>> before you get too excited
>> about raid6check.
> Sure it's not a magic wand for all situations... and raid6check itself
> seems to be rather at a early starting point...
> 
>> You can only trust its decisions when you are
>> confident that the problems it finds are *only* due to silent read
>> errors.
> Sure.... but at least it can be misused as kinda poor-man's integrity
> check.
> 
> AFAIU it's not yet working, that it can tell you back through the fs,
> which file is affected?

The block layer has no knowledge which file a block belongs to. Even for
file systems that is hard task to figure out, as only inodes store
information which blocks they use. So if you would want to figure out
the corresponding file, you first need to scan through all inodes and
search for the specific block. Once you have the corresponding inode you
need to find directory-entries referencing it. So lots of expensive
reverse searching.



Cheers,
Bernd

