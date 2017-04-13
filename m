From: Scott Ellentuch <tuctboh@gmail.com>
Subject: Re:
Date: Thu, 13 Apr 2017 12:38:59 -0400
Message-ID: <CAM-0sLwx+NKeNYY269xAyhKp0LV4gR9ZueEWAvET4nw6C9v45g@mail.gmail.com>
References: <CAM-0sLzUKM6jbda-j6d+kkY7Vfs7gGtU7wNr11tjFtVCDdU2YQ@mail.gmail.com>
 <CAK2H+efb3iKA5P3yd7uRqJomci6ENvrB1JRBBmtQEpEvyPMe7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efb3iKA5P3yd7uRqJomci6ENvrB1JRBBmtQEpEvyPMe7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

DOH! Stared at it for a while... Thanks.

Tuc

On Thu, Apr 13, 2017 at 12:22 PM, Mark Knecht <markknecht@gmail.com> wrote:
>
>
> On Thu, Apr 13, 2017 at 8:58 AM, Scott Ellentuch <tuctboh@gmail.com> wrote:
>>
>> for disk in a b c d g h i j k l m n
>> do
>>
>>   disklist="${disklist} /dev/sd${disk}1"
>>
>> done
>>
>> mdadm --create --verbose /dev/md2 --level=5 --raid=devices=12  ${disklist}
>>
>> But its telling me :
>>
>> mdadm: invalid number of raid devices: devices=12
>>
>>
>> I can't find any definition of a limit anywhere.
>>
>> Thank you, Tuc
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Try
>
> --raid-devices=12
>
> not
>
> --raid=devices=12
