From: John Stoffel <john@stoffel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Wed, 4 Oct 2017 21:26:58 -0400
Message-ID: <F48A217B-C892-4EA7-8451-6056BE92AD02@stoffel.org>
References: <22997.8664.67459.119616@quad.stoffel.home> <87a81637lq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a81637lq.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's trivial to revert if you know the starting size!  And I would argue that the --size option is misnamed, since is is a per-component resize.  

In any case, would it be better to print a message which said something like: array md## devices resized from <orig> to <new size>

When the user does this?  But again, I think the --force option is good to have when reducing the size of component devices, sine I would hope the message gives people a pause and hopefully makes them think.

So I really don't think we're holding people back, we're educating them with this warning.  

Sent from my iPhone

> On Oct 4, 2017, at 5:50 PM, NeilBrown <neilb@suse.com> wrote:
> 
>> On Wed, Oct 04 2017, John Stoffel wrote:
>> 
>> Since Eli had such a horrible experience where he shrunk the
>> individual component raid device size, instead of growing the overall
>> raid by adding a device, I came up with this hacky patch to warn you
>> when you are about to shoot yourself in the foot.
>> 
>> The idea is it will warn you and exit unless you pass in the --force
>> (or -f) switch when using the command.  For example, on a set of loop
>> devices:
>> 
>>    # cat /proc/mdstat
>>    Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>>    [raid4] [multipath] [faulty]
>>    md99 : active raid6 loop4p1[4] loop3p1[3] loop2p1[2] loop1p1[1]
>>    loop0p1[0]
>>      606720 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5]
>>      [UUUUU]
>> 
>>    # ./mdadm --grow /dev/md99 --size 128
>>    mdadm: Cannot set device size smaller than current component_size of /dev/md99 array.  Use -f to force change.
>> 
>>    # ./mdadm --grow /dev/md99 --size 128 -f
>>    mdadm: component size of /dev/md99 has been set to 0K
>> 
> 
> I'm not sure I like this.
> The reason that mdadm will quietly accept a size change like this is
> that it is trivial to revert - just set the same to a big number and all
> your data is still there.
> 
> Eli's problem was that he made a harmless mistake, realized that he had
> made a mistake, but didn't address the mistake before continuing!
> 
> If you really want to make this a two-step process, an approach that
> would be more consistent with other aspects of mdadm is to require that
> --array-size be reduced first.  i.e. setting --size mustn't reduce the
> size of the array.
> I think that separating the two steps (resize array, resize component)
> gives the user a better picture of what is happening, where as requiring
> -f just causes people to use -f more often.
> 
> Thanks,
> NeilBrown
> 
> 
>> 
>> I suspect I could do a better job of showing the original component
>> size, so that you have a chance of recovering even then.
>> 
>> But the patch:
>> 
>> diff --git a/Grow.c b/Grow.c
>> index 455c5f9..701590f 100755
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -1561,7 +1561,7 @@ static int reshape_container(char *container, char *devname,
>>                 char *backup_file, int verbose,
>>                 int forked, int restart, int freeze_reshape);
>> 
>> -int Grow_reshape(char *devname, int fd,
>> +int Grow_reshape(char *devname, int fd, int force,
>>         struct mddev_dev *devlist,
>>         unsigned long long data_offset,
>>         struct context *c, struct shape *s)
>> @@ -1574,6 +1574,7 @@ int Grow_reshape(char *devname, int fd,
>>     * requested everything (if kernel supports freezing - 2.6.30).
>>     * The steps are:
>>     *  - change size (i.e. component_size)
>> +         *    - when shrinking, you must force the change 
>>     *  - change level
>>     *  - change layout/chunksize/ndisks
>>     *
>> @@ -1617,6 +1618,11 @@ int Grow_reshape(char *devname, int fd,
>>        return 1;
>>    }
>> 
>> +    if ((s->size < (unsigned)array.size) && !force) {
>> +        pr_err("Cannot set device size smaller than current component_size of %s array.  Use -f to force change.\n",devname);
>> +        return 1;
>> +    }
>> +
>>    if (s->raiddisks && s->raiddisks < array.raid_disks && array.level > 1 &&
>>        get_linux_version() < 2006032 &&
>>        !check_env("MDADM_FORCE_FEWER")) {
>> diff --git a/ReadMe.c b/ReadMe.c
>> index 50d3807..46988ae 100644
>> --- a/ReadMe.c
>> +++ b/ReadMe.c
>> @@ -203,6 +203,7 @@ struct option long_options[] = {
>>     {"invalid-backup",0,0,InvalidBackup},
>>     {"array-size", 1, 0, 'Z'},
>>     {"continue", 0, 0, Continue},
>> +    {"force",      0, 0, Force},
>> 
>>     /* For Incremental */
>>     {"rebuild-map", 0, 0, RebuildMapOpt},
>> @@ -563,6 +564,7 @@ char Help_grow[] =
>> "                      : This is useful if all devices have been replaced\n"
>> "                      : with larger devices.   Value is in Kilobytes, or\n"
>> "                      : the special word 'max' meaning 'as large as possible'.\n"
>> +"  --force       -f    : Override normal checks and be more forceful\n"
>> "  --assume-clean      : When increasing the --size, this flag will avoid\n"
>> "                      : a resync of the new space\n"
>> "  --chunk=       -c   : Change the chunksize of the array\n"
>> diff --git a/mdadm.c b/mdadm.c
>> index c3a265b..821658a 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -1617,7 +1617,7 @@ int main(int argc, char *argv[])
>>        else if (s.size > 0 || s.raiddisks || s.layout_str ||
>>             s.chunk != 0 || s.level != UnSet ||
>>             data_offset != INVALID_SECTORS) {
>> -            rv = Grow_reshape(devlist->devname, mdfd,
>> +            rv = Grow_reshape(devlist->devname, mdfd, c.force,
>>                      devlist->next,
>>                      data_offset, &c, &s);
>>        } else if (array_size == 0)
>> diff --git a/mdadm.h b/mdadm.h
>> index 71b8afb..9e00f05 100644
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -1300,7 +1300,7 @@ extern int autodetect(void);
>> extern int Grow_Add_device(char *devname, int fd, char *newdev);
>> extern int Grow_addbitmap(char *devname, int fd,
>>              struct context *c, struct shape *s);
>> -extern int Grow_reshape(char *devname, int fd,
>> +extern int Grow_reshape(char *devname, int fd, int force,
>>            struct mddev_dev *devlist,
>>            unsigned long long data_offset,
>>            struct context *c, struct shape *s);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

