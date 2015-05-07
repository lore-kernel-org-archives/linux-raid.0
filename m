From: Abhijit Bhopatkar <abhopatk@cisco.com>
Subject: Re: Potential race in dlm based messaging md-cluster.c
Date: Thu, 07 May 2015 14:44:21 +0530
Message-ID: <554B2CED.5050903@cisco.com>
References: <CAE3Hb8oss1JZ2u7g7OQQgrEtgQ1vbQou04isiS6eEqbS=uzbhw@mail.gmail.com> <CAE3Hb8qNczD30RrcHFYCR90Jf9QFD-XH=x89MAu4Dpmm80se0A@mail.gmail.com> <554251EA.3000807@suse.com> <CAE3Hb8pJ=0MB6EX5jVch28gj-gnf0Mp1wyzxBfWjzLf=SuV4sQ@mail.gmail.com> <5542763C.90202@cisco.com> <5548FC6C020000E100022FA0@relay2.provo.novell.com> <5548911B.1080702@cisco.com> <5548B32B.5070904@cisco.com> <554B41BE020000E10002348B@relay2.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <554B41BE020000E10002348B@relay2.provo.novell.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, Goldwyn Rodrigues <RGoldwyn@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/05/15 8:13 am, Lidong Zhong wrote:
>>>> On 5/5/2015 at 08:10 PM, in message <5548B32B.5070904@cisco.com>, Abhijit
> Bhopatkar <abhopatk@cisco.com> wrote:
>> On 05/05/15 3:14 pm, Abhijit Bhopatkar wrote:
>>> On 05/05/15 2:52 pm, Lidong Zhong wrote:
>>>>>>> On 5/1/2015 at 02:36 AM, in message <5542763C.90202@cisco.com>, Abhijit
>>>> Bhopatkar <abhopatk@cisco.com> wrote:
>>
>> <snip>
>>
>>>>>
>>>>> To illustrate the problem consider timeline for two senders and one
>>>>> receiver (we will ignore receive part for Sender2 node)
>>>>>
>>>>> Sender1              Sender2                         Receiver
>>>>> Get EX on TOKEN       Get EX on TOKEN
>>>>> <Granted>                    <Wait till granted>
>>>>>
>>>>> Get EX on MSG
>>>>> write LVB
>>>>> down MSG to CR
>>>>> Get EX of ACK
>>>>> <wait till granted>
>>>>>         BAST for ACK
>>>>>                                                                Get CR on MSG
>>>>>                        read LVB
>>>>>                        process
>>>>>                        release ACK
>>>>> AST for ACK
>>>>> down ACK to CR
>>>>> release MSG
>>>>> release TOKEN
>>>>>                       <granted>
>>>>>                       Get EX on MSG
>>>>
>>>> I am afraid this corner case could not be achieved ever. Sender2 will be
>> blocked on getting
>>>> EX lock on MSG resource until the receivers release the lock. The
>> receivers' request on
>>>> upconverting CR to EX on MSG should be put into the convert queue before
>> Sender2's
>>>> request being put into the wait queue, because sender2 has to wait until
>> the EX on TOKEN
>>>> is released.
>>>>
>>> Yes my initial though of losing a message is not correct. The EX on message
>> won't be granted
>>> immediately to Sender2 However there is still a deadlock.
>>>
>>> Perhaps i am missing something, but according to me nothing prevents
>> Sender2 from acquiring
>>> EX on TOKEN _and_ MESSAGE __before__ up convert from reciever is queued.
>> Consider adding
>>> unusual delay right after ACK is released on receiver. The Sender1 will
>> immediately release
>>> MESSAGE and TOKEN. The receiver is still delayed for whatever reason.
>> Sender2 gets TOKEN grant
>>> and immediately queues EX for MESSAGE (note this is before EX for MESSAGE
>> is queued by receiver).
>>>
>
> Yes, there is a possibility leading to deadlock here.
>>> DLM will (should?) return error for the up convert saying there is deadlock
>> (-EDEADLK ??)
>>>
>>
>> On further investigation in dlm code. Since we do not set DLM_LKF_CONVDEADLK
>> flag on our locks,
>> in above deadlock case receiver's request to up convert will be simply
>> canceled. And the code
>> will proceed as expected since receiver still holds CR on MESSAGE. And then
>> after the processing
>> we will release the CR.
>>
>> So now my question is changed to;
>>
>> Why do we up convert the MESSAGE to EX in the first place?
>>
>> Was receiver EX on MESSAGE intended to serialize all receivers before taking
>> CR on ACK?
>>
>
> Yes, it is. Otherwise, each receiver may get duplicate messages when they try to
> get CR on ACK while the sender doesn't downconvert EX on ACK in time.

If I am reading this right, are we afraid of getting second BAST call on receiver?
Sender is holding EX on ACK, receiver releases CR of ACK after processing the message.
But sender is delayed in releasing EX on ACK. Receiver re-queues CR on ACK, which
might trigger BAST? (Note receiver won't get CR grant until sender released EX).

A new CR by receiver on ACK will _not_ trigger BAST call. Instead no AST will be called
until the original EX on ACK by sender is not released. BAST is called only on locks
that are already granted. Since we trigger message processing only on BAST I don't
see a possibility of duplicate message here.

>
> What I can think of a way to fix the deadlock now is setting the DLM_LKF_NOQUEUE
> flag when the sender tries to get EX on MESSAGE. It should keep trying until all the
> receivers release their locks on MESSAGE. Do you have any better idea without adding
> more lock resources? Since we already have three for transmitting messages.
>
Its exactly what I was thinking about and sounds like a good solution. However
as said  above I don't think receiver EX on ACK is really needed.

Regards,
Abhijit

> Regards,
> Lidong
>
>
>> Since there is a possibility that we might lose out on this up convert in a
>> race  condition, can
>> we simply eliminate this up conversion? (since CR is preventing the next
>> Sender from taking
>> EX on MESSAGE anyway).
>>
>> Regards,
>> Abhijit
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>

